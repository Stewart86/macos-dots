# macos-dots

Mac-focused dotfiles and bootstrap for Stewart's setup.

## One-liner

```bash
git clone https://github.com/Stewart86/macos-dots.git ~/macos-dots && cd ~/macos-dots && ./bootstrap.sh
```

## What it does

- installs Homebrew formulae and app casks from `Brewfile`
- installs Oh My Zsh and core plugins
- links the tracked config files into `~`
- keeps backups of existing files under `~/.dotfiles-backups/<timestamp>/`

## Notes

- Git identity is intentionally not managed here
- No secrets, SSH keys, AWS credentials, or work-specific creds are included
- Helium is intentionally skipped because the Homebrew cask is deprecated
