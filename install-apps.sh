#!/usr/bin/env bash
set -euo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RESET='\033[0m'
info()    { echo -e "${GREEN}[apps]${RESET} $*"; }
warn()    { echo -e "${YELLOW}[apps]${RESET} $*"; }
error()   { echo -e "${RED}[apps]${RESET} $*" >&2; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="${1:-$SCRIPT_DIR/apps.yaml}"

usage() {
	echo "Usage: $0 [path-to-apps.yaml]"
	echo "Default config: $SCRIPT_DIR/apps.yaml"
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
	usage
	exit 0
fi

if [[ ! -f "$CONFIG_FILE" ]]; then
	error "Config file not found: $CONFIG_FILE"
	exit 1
fi

if ! command -v brew &>/dev/null; then
	info "Installing Homebrew..."
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	eval "$(/opt/homebrew/bin/brew shellenv)" 2>/dev/null || eval "$(/usr/local/bin/brew shellenv)"
else
	info "Homebrew already installed."
fi

if ! command -v yq &>/dev/null; then
	info "Installing yq for YAML parsing..."
	brew install yq
fi

read_yaml_list() {
	local path="$1"
	yq -r "(${path} // []) | .[]" "$CONFIG_FILE"
}

read_yaml_scalar() {
	local path="$1"
	yq -r "${path} // \"\"" "$CONFIG_FILE"
}

formulae=()
while IFS= read -r formula; do
	[[ -n "$formula" ]] && formulae+=("$formula")
done < <(read_yaml_list '.apps."homebrew-formula"')

casks=()
while IFS= read -r cask; do
	[[ -n "$cask" ]] && casks+=("$cask")
done < <(read_yaml_list '.apps."homebrew-cask"')

taps=()
while IFS= read -r tap; do
	[[ -n "$tap" ]] && taps+=("$tap")
done < <(read_yaml_list '.apps."homebrew-taps"')

followup_message="$(read_yaml_scalar '.apps."followup-message"')"

info "Using config: $CONFIG_FILE"

if [[ ${#taps[@]} -eq 0 && ${#formulae[@]} -eq 0 && ${#casks[@]} -eq 0 ]]; then
	warn "No apps found in YAML under apps.homebrew-taps, apps.homebrew-formula, or apps.homebrew-cask"
	exit 0
fi

install_tap() {
	local tap="$1"
	local output
	if brew tap | grep -q "^${tap}$"; then
		info "Tap already added: $tap"
	else
		info "Adding tap: $tap"
		if ! output="$(brew tap "$tap" 2>&1)"; then
			if printf '%s' "$output" | grep -qi 'was deprecated'; then
				warn "Tap deprecated or empty: $tap. Continuing."
			else
				warn "Unable to add tap: $tap. Continuing."
			fi
		fi
	fi
}

install_formula() {
	local formula="$1"
	local output
	if brew list "$formula" &>/dev/null; then
		info "Formula already installed: $formula"
	else
		info "Installing formula: $formula"
		if ! output="$(brew install "$formula" 2>&1)"; then
			warn "Failed to install formula: $formula. Continuing."
			warn "$output"
		fi
	fi
}

install_cask() {
	local cask="$1"
	local output
	if brew list --cask "$cask" &>/dev/null; then
		info "Cask already installed: $cask"
	else
		info "Installing cask: $cask"
		if ! output="$(brew install --cask "$cask" 2>&1)"; then
			if printf '%s' "$output" | grep -q "already an App at '/Applications/"; then
				warn "App already exists for cask: $cask. Skipping."
			else
				warn "Failed to install cask: $cask. Continuing."
				warn "$output"
			fi
		fi
	fi
}

if [[ ${#taps[@]} -gt 0 ]]; then
	info "Adding Homebrew taps..."
	for tap in "${taps[@]}"; do
		install_tap "$tap"
	done
else
	info "No homebrew-taps entries found in $CONFIG_FILE"
fi

if [[ ${#formulae[@]} -gt 0 ]]; then
	info "Installing command-line tools..."
	for formula in "${formulae[@]}"; do
		install_formula "$formula"
	done
else
	warn "No homebrew-formula entries found in $CONFIG_FILE"
fi

if [[ ${#casks[@]} -gt 0 ]]; then
	info "Installing desktop apps..."
	for cask in "${casks[@]}"; do
		install_cask "$cask"
	done
else
	warn "No homebrew-cask entries found in $CONFIG_FILE"
fi

info "Done. Edit apps.yaml to add or remove formulae and casks for baseline machine setup."

if [[ -n "$followup_message" ]]; then
	echo
	info "Follow-up"
	printf '%s\n' "$followup_message"
fi
