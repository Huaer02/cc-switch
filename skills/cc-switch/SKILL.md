---
name: cc-switch
description: "Install and configure the cc provider/key switcher for Claude Code. Use when setting up a new machine to quickly switch between multiple API keys/providers with a single command."
user-invocable: true
---

# cc-switch: Provider/Key Switcher for Claude Code

This skill installs `cc`, a shell function that lets you switch between multiple API keys and providers when launching Claude Code.

## Usage after install

```bash
cc xcode1        # launch with specific provider
cc               # interactive selection
cc --list        # show all providers
```

## Installation

Run these steps to install cc-switch on this machine:

1. Copy `cc.sh` to `~/.claude/cc.sh`:

```bash
curl -fsSL https://raw.githubusercontent.com/Huaer02/cc-switch/main/cc.sh -o ~/.claude/cc.sh
chmod +x ~/.claude/cc.sh
```

2. Add to `~/.zshrc` (if not already present):

```bash
grep -q 'source ~/.claude/cc.sh' ~/.zshrc || echo '\n# Claude Code provider switcher\nsource ~/.claude/cc.sh' >> ~/.zshrc
```

3. Create `~/.claude/providers.json` from template:

```bash
cp providers.example.json ~/.claude/providers.json
```

4. Edit `~/.claude/providers.json` to add your actual keys:

```json
{
  "providers": {
    "my-key": {
      "description": "My API provider",
      "base_url": "https://api.example.com",
      "auth_token": "sk-your-key-here"
    }
  },
  "default": "my-key"
}
```

For providers with custom model names (like mimo), add model fields:

```json
{
  "providers": {
    "mimo": {
      "description": "xiaomimimo",
      "base_url": "https://token-plan-cn.xiaomimimo.com/anthropic",
      "auth_token": "tp-your-token",
      "model": "mimo-v2.5-pro",
      "sonnet_model": "mimo-v2.5-pro",
      "opus_model": "mimo-v2.5",
      "haiku_model": "mimo-v2.5-flash"
    }
  }
}
```

5. Source and test:

```bash
source ~/.zshrc
cc --list
```

## Managing providers

All providers live in `~/.claude/providers.json`. To add/rename/remove a provider, just edit that file. Changes take effect on next `cc` invocation.
