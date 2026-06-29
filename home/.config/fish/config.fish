# Ensure Homebrew (Apple Silicon) paths take priority
fish_add_path /opt/homebrew/bin /opt/homebrew/sbin

if status is-interactive
    fish_vi_key_bindings
end
