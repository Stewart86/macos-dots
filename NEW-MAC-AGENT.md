# New Mac Agent Guide

Use this repository as the source of truth for setting up Stewart's new Mac.

## Goals

- restore apps from [Brewfile](/Users/stewart.w/macos-dots/Brewfile)
- restore tracked dotfiles via [bootstrap.sh](/Users/stewart.w/macos-dots/bootstrap.sh)
- restore scriptable macOS settings via [macos-defaults.sh](/Users/stewart.w/macos-dots/macos-defaults.sh)
- identify any manual-only setup that still needs attention

## Recommended workflow

1. Confirm Homebrew is installed.
2. Clone `https://github.com/Stewart86/macos-dots.git` to `~/macos-dots`.
3. Run `./bootstrap.sh`.
4. Run `./macos-defaults.sh`.
5. Restart the Mac or log out and back in if settings appear partially applied.
6. Verify key apps launch and the symlinked configs are active.

## What is already captured

- Homebrew packages and casks in [Brewfile](/Users/stewart.w/macos-dots/Brewfile)
- shell, AeroSpace, Ghostty, Yazi, Lazygit, Neovim, Zed, oh-my-posh, and opencode config files
- a curated subset of macOS defaults for Finder, Dock, menu bar clock, mouse, trackpad, and screenshots

## What still needs manual setup

- Apple ID and iCloud settings
- Accessibility, Screen Recording, Automation, and Full Disk Access permissions
- browser sign-in, profiles, bookmarks, and extensions
- Raycast settings and extensions unless they are synced separately
- Obsidian vault access and plugin state unless they are synced separately
- app logins for Telegram, WhatsApp, Codex, GitHub, AWS, and similar tools
- SSH keys, GPG keys, API keys, and any other secrets not stored in this repo
- Finder sidebar favorites, Dock pinned apps, and other UI state not reliably captured by `defaults`

## How the agent should help

- prefer updating tracked files in this repo instead of making one-off local tweaks
- before changing system settings, compare the current machine against [macos-defaults.sh](/Users/stewart.w/macos-dots/macos-defaults.sh)
- when a setup step cannot be automated, add it to the manual checklist instead of pretending it is complete
- avoid destructive actions on an existing machine unless Stewart explicitly asks

## Suggested verification checks

- `brew bundle check --file Brewfile`
- `ls -l ~/.zshrc ~/.aerospace.toml`
- `defaults read com.apple.finder`
- `defaults read com.apple.dock`
- `aerospace list-modes`

## Recovery note

If something looks off, prefer fixing the tracked config here and re-running the setup rather than hand-editing the new Mac in a way that will be forgotten later.
