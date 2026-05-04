---
name: brew-install
description: Install macOS command-line tools and GUI apps with Homebrew while keeping the user's tracked Brewfile reproducible. Use when the user asks to install an app, CLI, package, tool, font, cask, formula, tap-backed package, or says "install something" in a macOS/Homebrew context, especially inside the macos-dots repo.
---

# Brew Install

## Core Rule

Prefer a reproducible Brewfile install over an ad hoc one-off install.

Default flow:

1. Identify the right Homebrew artifact: formula, cask, font cask, or tap-qualified formula/cask.
2. Update the relevant `Brewfile`.
3. Run `brew bundle --file <path-to-Brewfile>`.
4. Verify the install and report what changed.

Use direct `brew install` or `brew install --cask` only when no suitable Brewfile exists, the user explicitly asks for a one-off install, or `brew bundle` cannot be used. If a direct install is used and a tracked Brewfile exists, still add the installed item to that Brewfile afterward.

## Finding The Brewfile

When working in `/Users/stewart.w/macos-dots`, use `/Users/stewart.w/macos-dots/Brewfile`.

Otherwise:

- Check the current repo for `Brewfile` first.
- If none exists, check obvious dotfiles/setup repos before creating anything.
- Ask before creating a new Brewfile unless the user explicitly requested repo setup.

Do not modify unrelated install scripts unless the repo already uses them as part of the package flow. In `macos-dots`, `brew bundle --file "$REPO_DIR/Brewfile"` is the canonical package install path, so adding to `Brewfile` is usually enough.

## Classify Before Editing

Resolve formula vs cask before changing files.

Useful checks:

```bash
brew search <name>
brew info <name>
brew info --cask <name>
brew search --casks <name>
brew search --formulae <name>
```

Selection rules:

- Use `brew "<name>"` for command-line tools, libraries, shells, runtimes, and background formulae.
- Use `cask "<name>"` for GUI apps, fonts, preference panes, and `.app` installs.
- Use `cask "font-..."` for fonts unless Homebrew documents a different artifact.
- Add `tap "<owner>/<repo>"` when Homebrew requires a non-core tap.
- Use tap-qualified names when needed to avoid ambiguity, for example `brew "owner/repo/formula"` or `cask "owner/repo/cask"`.

If a package exists as both formula and cask, choose by the user's intent:

- CLI usage -> formula.
- Desktop app -> cask.
- Both are genuinely needed -> add both, and explain why.

## Editing Brewfile

Keep the existing style and grouping:

- `tap` entries near other taps.
- `brew` entries near other formulae.
- `cask` entries near other casks.
- Preserve existing ordering style where practical; if the file is alphabetical by section, insert alphabetically.
- Do not duplicate entries.
- Use `apply_patch` for manual edits.

Before adding, search the file for existing entries and aliases.

## Install And Verify

After editing:

```bash
brew bundle --file /path/to/Brewfile
```

Then verify based on artifact type:

- Formula: run `<command> --version`, `brew list <name>`, or another meaningful smoke check.
- Cask app: run `brew list --cask <name>` and, when useful, confirm the `.app` exists.
- Service/formula with a LaunchAgent: use the repo's established service/bootstrap pattern; do not invent new startup management.

If `brew bundle` fails because the entry name is wrong, fix the Brewfile and rerun it. If it fails due to network, permissions, or upstream availability, report the failure clearly and leave the Brewfile edit only if the entry is confirmed correct.

## Reporting

Keep the final answer concrete:

- Say whether the package was added as `brew`, `cask`, or `tap` plus package.
- Name the Brewfile path changed.
- State the install command run and the verification result.
- Mention any failure or skipped validation directly.
