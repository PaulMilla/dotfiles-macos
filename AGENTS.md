# AGENTS.md

## Scope
- This repo manages macOS user dotfiles with GNU Stow.
- The only managed package today is [home](home), which mirrors paths under `$HOME`.
- System-level files outside `$HOME` are currently out of scope unless the repo structure is extended explicitly.

## Key Files
- [install.sh](install.sh): bootstraps Homebrew if needed, installs GNU Stow, backs up conflicting real files to `*.backup`, then runs `stow`.
- [home](home): canonical source of truth for managed dotfiles. Add new files here using the same path they should have under `$HOME`.
- [.gitignore](.gitignore): excludes local macOS noise and Karabiner-generated backup/assets directories.

## Working Rules
- Prefer editing files under [home](home), not their symlinked counterparts in `$HOME`.
- When adding a new managed dotfile, place it under [home](home) with the correct relative path, then rerun `./install.sh`.
- Preserve the repo's current model: one Stow package, minimal automation, backup-before-link behavior.
- Do not add generated or machine-local files such as shell histories, `.zcompdump`, `.DS_Store`, or app backup folders unless the user explicitly asks.
- Be careful with secrets and machine-specific credentials in files like [home/.gitconfig](home/.gitconfig). Flag them before broadening what is tracked.

## Validation
- For installer changes, run `./install.sh` from the repo root.
- For Stow-specific verification, use `stow --simulate --target="$HOME" --dir="$PWD" home` before applying broader layout changes.
- After changes, verify symlinks or repo state with focused checks such as `git status --short` or `ls -l ~/.zshrc`.

## Common Pitfalls
- Stow refuses to overwrite existing real files; this repo handles that by moving them to `*.backup` first.
- Editing a managed file through its path in `$HOME` works because it is symlinked, but agents should still prefer the repo copy for clarity.
- Karabiner creates noisy generated content outside the main config file; keep only the intended config under version control.
