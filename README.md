# macos-dots

Mac-focused dotfiles and bootstrap for Stewart's setup.

## One-liner

```bash
git clone https://github.com/Stewart86/macos-dots.git ~/macos-dots && cd ~/macos-dots && ./bootstrap.sh
```

## Codex desktop app

The Homebrew `codex` cask is the terminal Codex package, not the desktop app.

Install the actual desktop app from OpenAI directly:
https://developers.openai.com/codex/app

## What it does

- installs Homebrew formulae and app casks from `Brewfile`
- installs Oh My Zsh and core plugins
- links the tracked config files into `~`
- installs tracked LaunchAgents for login-time apps
- installs a basic AeroSpace tiling setup
- bootstraps OpenCode CLI and Codex CLI
- documents Codex desktop app install separately
- keeps backups of existing files under `~/.dotfiles-backups/<timestamp>/`

## Notes

- Git identity is intentionally not managed here
- GitHub auth/setup is intentionally not managed here yet
- No secrets, SSH keys, AWS credentials, or work-specific creds are included
- OpenCode config is sanitized, Context7 stays disabled until you add your own key
- Helium is intentionally skipped because the Homebrew cask is deprecated
