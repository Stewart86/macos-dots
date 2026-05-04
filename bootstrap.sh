#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_ROOT="$HOME/.dotfiles-backups/$(date +%Y%m%d-%H%M%S)"

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || { echo "Missing required command: $1" >&2; exit 1; }
}

backup_if_exists() {
  local target="$1"
  if [ -L "$target" ] || [ -e "$target" ]; then
    mkdir -p "$BACKUP_ROOT$(dirname "$target")"
    mv "$target" "$BACKUP_ROOT$target"
    echo "Backed up $target -> $BACKUP_ROOT$target"
  fi
}

link_path() {
  local src="$1"
  local dest="$2"
  mkdir -p "$(dirname "$dest")"
  ln -sfn "$src" "$dest"
  echo "Linked $dest -> $src"
}

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew is required first: https://brew.sh" >&2
  exit 1
fi

eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv)"

brew bundle --file "$REPO_DIR/Brewfile"

if command -v borders >/dev/null 2>&1; then
  brew services start felixkratz/formulae/borders || true
fi

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
[ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] || git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
[ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] || git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
[ -d "$ZSH_CUSTOM/plugins/fast-syntax-highlighting" ] || git clone https://github.com/zdharma-continuum/fast-syntax-highlighting "$ZSH_CUSTOM/plugins/fast-syntax-highlighting"

backup_if_exists "$HOME/.zshrc"
backup_if_exists "$HOME/.hushlogin"
backup_if_exists "$HOME/.aerospace.toml"
backup_if_exists "$HOME/.config/ghostty/config"
backup_if_exists "$HOME/.config/ohmyposh/zen.toml"
backup_if_exists "$HOME/.config/zed/settings.json"
backup_if_exists "$HOME/.config/zed/keymap.json"
backup_if_exists "$HOME/Library/Application Support/Zed/settings.json"
backup_if_exists "$HOME/Library/Application Support/Zed/keymap.json"
backup_if_exists "$HOME/.config/yazi/yazi.toml"
backup_if_exists "$HOME/.config/lazygit/config.yml"
backup_if_exists "$HOME/.config/opencode/opencode.jsonc"
backup_if_exists "$HOME/.config/opencode/agent"
backup_if_exists "$HOME/.config/opencode/skill"
backup_if_exists "$HOME/.config/nvim"
backup_if_exists "$HOME/Library/LaunchAgents/eu.exelban.Stats.plist"
backup_if_exists "$HOME/Library/LaunchAgents/com.mowglii.ItsycalApp.plist"

link_path "$REPO_DIR/.zshrc" "$HOME/.zshrc"
link_path "$REPO_DIR/.hushlogin" "$HOME/.hushlogin"
link_path "$REPO_DIR/.aerospace.toml" "$HOME/.aerospace.toml"
link_path "$REPO_DIR/.config/ghostty/config" "$HOME/.config/ghostty/config"
link_path "$REPO_DIR/.config/ohmyposh/zen.toml" "$HOME/.config/ohmyposh/zen.toml"
link_path "$REPO_DIR/.config/yazi/yazi.toml" "$HOME/.config/yazi/yazi.toml"
link_path "$REPO_DIR/.config/lazygit/config.yml" "$HOME/.config/lazygit/config.yml"
link_path "$REPO_DIR/.config/opencode/opencode.jsonc" "$HOME/.config/opencode/opencode.jsonc"
link_path "$REPO_DIR/.config/opencode/agent" "$HOME/.config/opencode/agent"
link_path "$REPO_DIR/.config/opencode/skill" "$HOME/.config/opencode/skill"
link_path "$REPO_DIR/.config/zed/settings.json" "$HOME/.config/zed/settings.json"
link_path "$REPO_DIR/.config/zed/keymap.json" "$HOME/.config/zed/keymap.json"
link_path "$REPO_DIR/.config/zed/settings.json" "$HOME/Library/Application Support/Zed/settings.json"
link_path "$REPO_DIR/.config/zed/keymap.json" "$HOME/Library/Application Support/Zed/keymap.json"
link_path "$REPO_DIR/.config/nvim" "$HOME/.config/nvim"
link_path "$REPO_DIR/Library/LaunchAgents/eu.exelban.Stats.plist" "$HOME/Library/LaunchAgents/eu.exelban.Stats.plist"
link_path "$REPO_DIR/Library/LaunchAgents/com.mowglii.ItsycalApp.plist" "$HOME/Library/LaunchAgents/com.mowglii.ItsycalApp.plist"

launchctl bootout "gui/$(id -u)" "$HOME/Library/LaunchAgents/eu.exelban.Stats.plist" >/dev/null 2>&1 || true
launchctl bootstrap "gui/$(id -u)" "$HOME/Library/LaunchAgents/eu.exelban.Stats.plist" || true
launchctl kickstart -k "gui/$(id -u)/eu.exelban.Stats" >/dev/null 2>&1 || true
launchctl bootout "gui/$(id -u)" "$HOME/Library/LaunchAgents/com.mowglii.ItsycalApp.plist" >/dev/null 2>&1 || true
launchctl bootstrap "gui/$(id -u)" "$HOME/Library/LaunchAgents/com.mowglii.ItsycalApp.plist" || true
launchctl kickstart -k "gui/$(id -u)/com.mowglii.ItsycalApp" >/dev/null 2>&1 || true

chmod go-w "$(brew --prefix)/share" || true
chmod -R go-w "$(brew --prefix)/share/zsh" || true

export PATH="/opt/homebrew/opt/rustup/bin:$PATH"
rustup default stable || true

if command -v fnm >/dev/null 2>&1; then
  eval "$(fnm env --shell bash)"
  fnm install --lts
  fnm default lts-latest
  corepack enable || true
  corepack prepare pnpm@latest --activate || true
fi

if command -v bun >/dev/null 2>&1; then
  export PATH="$HOME/.bun/bin:$PATH"
  bun add -g opencode-ai || true
fi

if ! command -v codex >/dev/null 2>&1 && command -v npm >/dev/null 2>&1; then
  npm install -g @openai/codex || true
fi

echo
echo "Done. Restart Ghostty/Zed or run: exec zsh"
