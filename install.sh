#!/bin/zsh
# cc-switch installer
# Run: curl -fsSL https://raw.githubusercontent.com/Huaer02/cc-switch/main/install.sh | zsh

set -e

REPO_URL="https://raw.githubusercontent.com/Huaer02/cc-switch/main"
CC_DIR="$HOME/.claude"

echo "\033[36m[cc-switch]\033[0m Installing..."

# 1. Download cc.sh
curl -fsSL "$REPO_URL/cc.sh" -o "$CC_DIR/cc.sh"
chmod +x "$CC_DIR/cc.sh"
echo "\033[32m✓\033[0m cc.sh installed"

# 2. Create providers.json if not exists
if [[ ! -f "$CC_DIR/providers.json" ]]; then
  curl -fsSL "$REPO_URL/providers.example.json" -o "$CC_DIR/providers.json"
  echo "\033[32m✓\033[0m providers.json created (edit it to add your keys)"
else
  echo "\033[33m→\033[0m providers.json already exists, skipping"
fi

# 3. Add source line to .zshrc if not present
if ! grep -q 'source ~/.claude/cc.sh' ~/.zshrc 2>/dev/null; then
  printf '\n# Claude Code provider switcher\nsource ~/.claude/cc.sh\n' >> ~/.zshrc
  echo "\033[32m✓\033[0m Added to ~/.zshrc"
else
  echo "\033[33m→\033[0m ~/.zshrc already configured, skipping"
fi

echo ""
echo "\033[36m[cc-switch]\033[0m Done! Next steps:"
echo "  1. Edit ~/.claude/providers.json to add your API keys"
echo "  2. Run: source ~/.zshrc"
echo "  3. Try: cc --list"
