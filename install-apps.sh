#!/usr/bin/env bash
set -euo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RESET='\033[0m'
info()    { echo -e "${GREEN}[apps]${RESET} $*"; }
warn()    { echo -e "${YELLOW}[apps]${RESET} $*"; }
error()   { echo -e "${RED}[apps]${RESET} $*" >&2; }

if ! command -v brew &>/dev/null; then
	info "Installing Homebrew..."
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	eval "$(/opt/homebrew/bin/brew shellenv)" 2>/dev/null || eval "$(/usr/local/bin/brew shellenv)"
else
	info "Homebrew already installed."
fi

# Keep this list focused on reusable machine setup, not one-off local tools.
formulae=(
	git
	stow
	fish
)

# These casks are seeded from apps already reflected in this repo's configs.
casks=(
	kitty
	karabiner-elements
)

install_formula() {
	local formula="$1"
	if brew list "$formula" &>/dev/null; then
		info "Formula already installed: $formula"
	else
		info "Installing formula: $formula"
		brew install "$formula"
	fi
}

install_cask() {
	local cask="$1"
	if brew list --cask "$cask" &>/dev/null; then
		info "Cask already installed: $cask"
	else
		info "Installing cask: $cask"
		brew install --cask "$cask"
	fi
}

info "Installing command-line tools..."
for formula in "${formulae[@]}"; do
	install_formula "$formula"
done

info "Installing desktop apps..."
for cask in "${casks[@]}"; do
	install_cask "$cask"
done

info "Done. Edit install-apps.sh to add or remove formulae and casks for your baseline machine setup."
