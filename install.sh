#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="$HOME"

# ── Colours ───────────────────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RESET='\033[0m'
info()    { echo -e "${GREEN}[dotfiles]${RESET} $*"; }
warn()    { echo -e "${YELLOW}[dotfiles]${RESET} $*"; }
error()   { echo -e "${RED}[dotfiles]${RESET} $*" >&2; }

# ── Homebrew ──────────────────────────────────────────────────────────────────
if ! command -v brew &>/dev/null; then
  info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # Add brew to PATH for the rest of this script (Apple Silicon default path)
  eval "$(/opt/homebrew/bin/brew shellenv)" 2>/dev/null || eval "$(/usr/local/bin/brew shellenv)"
else
  info "Homebrew already installed."
fi

# ── GNU Stow ──────────────────────────────────────────────────────────────────
if ! command -v stow &>/dev/null; then
  info "Installing GNU Stow..."
  brew install stow
else
  info "GNU Stow already installed."
fi

# ── Back up any conflicting files ─────────────────────────────────────────────
# Stow will refuse to overwrite real files; we back them up first.
backup_if_real() {
  local file="$1"
  if [[ -e "$file" && ! -L "$file" ]]; then
    warn "Backing up existing file: $file -> ${file}.backup"
    mv "$file" "${file}.backup"
  fi
}

info "Checking for conflicts in the 'home' package..."
while IFS= read -r -d '' src; do
  # Derive the destination path by stripping the repo prefix + /home
  rel="${src#"$DOTFILES_DIR/home/"}"
  dst="$TARGET/$rel"
  backup_if_real "$dst"
done < <(find "$DOTFILES_DIR/home" -type f -print0)

# ── Stow ──────────────────────────────────────────────────────────────────────
info "Stowing 'home' package to $TARGET..."
stow --verbose=1 --target="$TARGET" --dir="$DOTFILES_DIR" home

info "Done! All dotfiles are symlinked."
