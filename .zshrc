eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv)"
export PATH="$HOME/.bun/bin:/opt/homebrew/opt/rustup/bin:$PATH"
export ZSH="$HOME/.oh-my-zsh"
export ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/oh-my-zsh"
export ZSH_COMPDUMP="$ZSH_CACHE_DIR/.zcompdump"

mkdir -p "$ZSH_CACHE_DIR/completions"

if command -v brew >/dev/null 2>&1; then
  FPATH="$(brew --prefix)/share/zsh/site-functions:$FPATH"
fi

plugins=(
  git
  sudo
  dirhistory
  fnm
  zsh-autosuggestions
  zsh-syntax-highlighting
  fast-syntax-highlighting
)

_omz_cached_init="$ZSH_CACHE_DIR/oh-my-zsh-cached-compinit.zsh"
if [[ ! -f "$_omz_cached_init" || "$ZSH/oh-my-zsh.sh" -nt "$_omz_cached_init" ]]; then
  command sed \
    -e 's/compinit -i -d "\$ZSH_COMPDUMP"/compinit -C -i -d "$ZSH_COMPDUMP"/' \
    -e 's/compinit -u -d "\$ZSH_COMPDUMP"/compinit -C -u -d "$ZSH_COMPDUMP"/' \
    "$ZSH/oh-my-zsh.sh" >| "$_omz_cached_init"
fi

source "$_omz_cached_init"

eval "$(fnm env --use-on-cd --shell zsh)"
eval "$(zoxide init zsh)"
eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/zen.toml)"

[ -f "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh" ] && source "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh"
[ -f "$(brew --prefix)/opt/fzf/shell/completion.zsh" ] && source "$(brew --prefix)/opt/fzf/shell/completion.zsh"

export EDITOR='nvim'
export VISUAL='nvim'

_fastfetch_logo_args=(
  --kitty-direct "$HOME/macos-dots/assets/mac-logo.png"
  --logo-width 14
  --logo-height 7
  --separator "  "
  --structure "OS:Shell:Terminal:WM:Packages:Memory:Uptime"
)

if [[ -o interactive ]] && command -v fastfetch >/dev/null 2>&1; then
  _fastfetch_terminal="${TERM_PROGRAM:-${LC_TERMINAL:-${TERM:-unknown}}}"
  _fastfetch_terminal="${_fastfetch_terminal:l}"
  _fastfetch_terminal="${_fastfetch_terminal//[^a-z0-9._-]/-}"
  _fastfetch_cache="$HOME/.cache/fastfetch-startup-${_fastfetch_terminal}.txt"
  _fastfetch_ttl=21600

  if [[ -f "$_fastfetch_cache" ]]; then
    command cat -- "$_fastfetch_cache"

    if (( $(date +%s) - $(stat -f %m "$_fastfetch_cache") > _fastfetch_ttl )); then
      (fastfetch --pipe false "${_fastfetch_logo_args[@]}" >| "$_fastfetch_cache") >/dev/null 2>&1 &
    fi
  else
    mkdir -p "$HOME/.cache"
    fastfetch --pipe false "${_fastfetch_logo_args[@]}" | tee "$_fastfetch_cache"
  fi
fi

alias c='clear'
alias ls='eza --icons'
alias ll='eza --icons -al'
alias lt='eza --icons -a --tree --level=1'
alias cat='bat'
alias v='nvim'
alias vi='nvim'
alias vim='nvim'
alias lg='lazygit'

ff() {
  fastfetch "${_fastfetch_logo_args[@]}" "$@"
}

nf() {
  fastfetch "${_fastfetch_logo_args[@]}" "$@"
}

function y() {
  local tmp="$(mktemp -t yazi-cwd.XXXXXX)" cwd
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}
