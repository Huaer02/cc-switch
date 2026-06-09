#!/usr/bin/env bash
# cc - Claude Code provider/key switcher
# Compatible with both bash and zsh

CC_PROVIDERS="$HOME/.claude/providers.json"

cc() {
  if [ -n "$ZSH_VERSION" ]; then
    setopt localoptions KSH_ARRAYS
  fi

  local _cyan=$'\033[36m' _green=$'\033[32m' _yellow=$'\033[33m'
  local _red=$'\033[31m' _dim=$'\033[2m' _reset=$'\033[0m'

  if [[ ! -f "$CC_PROVIDERS" ]]; then
    printf "%sError:%s %s not found\n" "$_red" "$_reset" "$CC_PROVIDERS"
    return 1
  fi

  local provider=""

  if [[ "$1" == "--list" || "$1" == "-l" ]]; then
    printf "%sAvailable providers:%s\n" "$_cyan" "$_reset"
    jq -r '.providers | to_entries[] | "\(.key)\t\(.value.description // "")"' "$CC_PROVIDERS" | while IFS=$'\t' read -r _k _d; do
      printf "  %s%s%s %s- %s%s\n" "$_green" "$_k" "$_reset" "$_dim" "$_d" "$_reset"
    done
    return 0
  fi

  if [[ -n "$1" && "$1" != -* ]]; then
    provider="$1"
    shift
    if ! jq -e ".providers[\"$provider\"]" "$CC_PROVIDERS" >/dev/null 2>&1; then
      printf "%sError:%s provider '%s%s%s' not found\n" "$_red" "$_reset" "$_yellow" "$provider" "$_reset"
      printf "Available: %s\n" "$(jq -r '.providers | keys | join(", ")' "$CC_PROVIDERS")"
      return 1
    fi
  elif [[ -z "$1" ]]; then
    local _names=()
    local _descs=()
    local _n _choice

    while IFS=$'\t' read -r _k _d; do
      _names+=("$_k")
      _descs+=("$_d")
    done < <(jq -r '.providers | to_entries[] | "\(.key)\t\(.value.description // "")"' "$CC_PROVIDERS")

    _n=${#_names[@]}
    if [[ $_n -eq 0 ]]; then
      printf "%sError:%s no providers configured\n" "$_red" "$_reset"
      return 1
    fi

    printf "%sSelect a provider:%s\n" "$_cyan" "$_reset"
    local _i
    for (( _i=0; _i<_n; _i++ )); do
      if [[ -n "${_descs[$_i]}" ]]; then
        printf "  %s%d)%s %s %s- %s%s\n" "$_green" "$((_i+1))" "$_reset" "${_names[$_i]}" "$_dim" "${_descs[$_i]}" "$_reset"
      else
        printf "  %s%d)%s %s\n" "$_green" "$((_i+1))" "$_reset" "${_names[$_i]}"
      fi
    done
    echo ""
    printf "Enter number [1-%d]: " "$_n"
    read -r _choice
    if [[ "$_choice" -ge 1 && "$_choice" -le "$_n" ]] 2>/dev/null; then
      provider="${_names[$((_choice-1))]}"
    else
      printf "%sInvalid choice%s\n" "$_red" "$_reset"
      return 1
    fi
  fi

  local base_url auth_token model sonnet_model opus_model haiku_model
  base_url=$(jq -r ".providers[\"$provider\"].base_url" "$CC_PROVIDERS")
  auth_token=$(jq -r ".providers[\"$provider\"].auth_token" "$CC_PROVIDERS")
  model=$(jq -r ".providers[\"$provider\"].model // empty" "$CC_PROVIDERS")
  sonnet_model=$(jq -r ".providers[\"$provider\"].sonnet_model // empty" "$CC_PROVIDERS")
  opus_model=$(jq -r ".providers[\"$provider\"].opus_model // empty" "$CC_PROVIDERS")
  haiku_model=$(jq -r ".providers[\"$provider\"].haiku_model // empty" "$CC_PROVIDERS")

  # Build --settings JSON to override settings.json env values
  local settings_json
  settings_json='{"env":{"ANTHROPIC_BASE_URL":"'"$base_url"'","ANTHROPIC_AUTH_TOKEN":"'"$auth_token"'"'
  [[ -n "$model" ]] && settings_json+=',"ANTHROPIC_MODEL":"'"$model"'"'
  [[ -n "$sonnet_model" ]] && settings_json+=',"ANTHROPIC_DEFAULT_SONNET_MODEL":"'"$sonnet_model"'"'
  [[ -n "$opus_model" ]] && settings_json+=',"ANTHROPIC_DEFAULT_OPUS_MODEL":"'"$opus_model"'"'
  [[ -n "$haiku_model" ]] && settings_json+=',"ANTHROPIC_DEFAULT_HAIKU_MODEL":"'"$haiku_model"'"'
  settings_json+='}}'

  local _desc
  _desc=$(jq -r ".providers[\"$provider\"].description // empty" "$CC_PROVIDERS")
  if [[ -n "$_desc" ]]; then
    printf "%s→%s Using: %s%s%s %s(%s)%s\n" "$_green" "$_reset" "$_cyan" "$provider" "$_reset" "$_dim" "$_desc" "$_reset"
  else
    printf "%s→%s Using: %s%s%s\n" "$_green" "$_reset" "$_cyan" "$provider" "$_reset"
  fi
  claude --settings "$settings_json" "$@"
}
