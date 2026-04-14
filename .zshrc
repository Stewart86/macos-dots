eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv)"
export PATH="$HOME/.bun/bin:/opt/homebrew/opt/rustup/bin:$PATH"
export ZSH="$HOME/.oh-my-zsh"

if command -v brew >/dev/null 2>&1; then
  FPATH="$(brew --prefix)/share/zsh/site-functions:$(brew --prefix)/share/zsh-completions:$FPATH"
fi

plugins=(
  git
  sudo
  dirhistory
  web-search
  fnm
  zsh-autosuggestions
  zsh-syntax-highlighting
  fast-syntax-highlighting
)

source "$ZSH/oh-my-zsh.sh"

eval "$(fnm env --use-on-cd --shell zsh)"
eval "$(zoxide init zsh)"
eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/zen.toml)"

[ -f "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh" ] && source "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh"
[ -f "$(brew --prefix)/opt/fzf/shell/completion.zsh" ] && source "$(brew --prefix)/opt/fzf/shell/completion.zsh"

alias c='clear'
alias nf='fastfetch'
alias ff='fastfetch'
alias ls='eza --icons'
alias ll='eza --icons -al'
alias lt='eza --icons -a --tree --level=1'
alias cat='bat'
alias v='nvim'
alias vi='nvim'
alias vim='nvim'
alias lg='lazygit'

function y() {
  local tmp="$(mktemp -t yazi-cwd.XXXXXX)" cwd
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}
