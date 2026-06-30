# Ensure Homebrew (Apple Silicon) paths take priority
fish_add_path /opt/homebrew/bin /opt/homebrew/sbin

# Make the VS Code CLI available in Fish even if the shell-command symlink is missing.
if test -d "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
    fish_add_path "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
end

# Personal helper scripts
fish_add_path ~/lib

# Ensure pnpm global binaries are available (used by `pnpm link --global`).
set -gx PNPM_HOME "$HOME/Library/pnpm"
if test -d "$PNPM_HOME/bin"
    fish_add_path "$PNPM_HOME/bin"
end

if status is-interactive
    fish_vi_key_bindings
end
