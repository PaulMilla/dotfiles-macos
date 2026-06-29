# Ensure Homebrew (Apple Silicon) paths take priority
fish_add_path /opt/homebrew/bin /opt/homebrew/sbin

# Make the VS Code CLI available in Fish even if the shell-command symlink is missing.
if test -d "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
    fish_add_path "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
end

# Personal helper scripts
fish_add_path ~/lib

if status is-interactive
    fish_vi_key_bindings
end
