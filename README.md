# dotfiles-macos

macOS dotfiles managed with GNU Stow.

This repo keeps the tracked files under [home](home), mirroring their paths under `$HOME`. Running [install.sh](install.sh) installs Stow if needed, backs up conflicting real files, and creates symlinks into your home directory.

## What This Repo Manages
- Shell config: `.zshrc`, `.zprofile`, `.bash_profile`
- Git config: `.gitconfig`
- App config under `.config/`, including Kitty, Karabiner, and Fish

## Layout
```text
dotfiles-macos/
├── home/
│   ├── .zshrc
│   ├── .zprofile
│   ├── .bash_profile
│   ├── .gitconfig
│   └── .config/
├── install.sh
├── .gitignore
└── AGENTS.md
```

Files under `home/` are the source of truth. After Stow links them into `$HOME`, editing either the repo copy or the symlinked path updates the same file, but it is clearer to edit the repo copy directly.

## Install
Clone the repo and run the installer:

```bash
git clone <your-repo-url> ~/github/dotfiles-macos
cd ~/github/dotfiles-macos
./install.sh
```

The installer will:
- install Homebrew if it is missing
- install GNU Stow if it is missing
- move conflicting real files to `*.backup`
- create symlinks from `$HOME` into this repo

## Daily Workflow
Make changes in this repo, then commit and push them:

```bash
cd ~/github/dotfiles-macos
git status
git add .
git commit -m "Update dotfiles"
git push
```

On another machine, pull the latest changes and rerun the installer if you add new managed files:

```bash
cd ~/github/dotfiles-macos
git pull
./install.sh
```

## Adding a New Dotfile
1. Add the file under `home/` using the same path it should have under `$HOME`.
2. Run `./install.sh`.
3. Verify the symlink was created.

Example:

```text
home/.config/starship.toml -> ~/.config/starship.toml
```

## Validation
For a dry run before larger layout changes:

```bash
stow --simulate --target="$HOME" --dir="$PWD" home
```

For a quick symlink check:

```bash
ls -l ~/.zshrc
```

## Notes
- This repo currently manages only user-level files under `$HOME`.
- Generated local files such as `.DS_Store`, shell history, `.zcompdump`, and Karabiner backup/assets directories should stay out of version control.
- Review files like `.gitconfig` before sharing broadly if they contain machine-specific settings or credential helpers.