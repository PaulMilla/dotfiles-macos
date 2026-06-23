# dotfiles-macos

macOS dotfiles managed with GNU Stow, plus bootstrap scripts for app installation.

This repo keeps tracked dotfiles under [home](home), mirroring their paths under `$HOME`. [install-dotfiles.sh](install-dotfiles.sh) installs Stow if needed, backs up conflicting real files, and creates symlinks into your home directory. [install-apps.sh](install-apps.sh) bootstraps Homebrew packages and cask apps for a new machine.

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
├── install-apps.sh
├── install-dotfiles.sh
├── .gitignore
└── AGENTS.md
```

Files under `home/` are the source of truth. After Stow links them into `$HOME`, editing either the repo copy or the symlinked path updates the same file, but it is clearer to edit the repo copy directly.

## Install
Clone the repo and run the installers you want:

```bash
git clone <your-repo-url> ~/github/dotfiles-macos
cd ~/github/dotfiles-macos
./install-apps.sh
./install-dotfiles.sh
```

`./install-apps.sh` will:
- install Homebrew if it is missing
- install baseline formulae such as `git`, `stow`, and `fish`
- install baseline cask apps such as `kitty` and `karabiner-elements`

`./install-dotfiles.sh` will:
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

On another machine, pull the latest changes and rerun the relevant installer if you add new managed files or baseline apps:

```bash
cd ~/github/dotfiles-macos
git pull
./install-apps.sh
./install-dotfiles.sh
```

## Adding a New Dotfile
1. Add the file under `home/` using the same path it should have under `$HOME`.
2. Run `./install-dotfiles.sh`.
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
- This repo currently manages only user-level files under `$HOME` for dotfiles.
- The app installer is intended for reusable baseline tooling and desktop apps, not every machine-specific package you might try once.
- Generated local files such as `.DS_Store`, shell history, `.zcompdump`, and Karabiner backup/assets directories should stay out of version control.
- Review files like `.gitconfig` before sharing broadly if they contain machine-specific settings or credential helpers.