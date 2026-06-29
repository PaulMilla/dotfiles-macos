# Tide prompt configuration
# This file stores Tide settings to sync across machines

# Left prompt items (vi_mode, pwd, git, newline)
set -Ux _tide_left_items vi_mode pwd git newline character

# Right prompt items (status, cmd_duration, context, jobs, etc.)
set -Ux _tide_right_items status cmd_duration context jobs node python java ruby terraform time

# Character styling
set -Ux tide_character_color 5FD700
set -Ux tide_character_color_failure FF0000
set -Ux tide_character_icon '❯'
set -Ux tide_character_vi_icon_default '❮'
set -Ux tide_character_vi_icon_replace '▶'
set -Ux tide_character_vi_icon_visual V

# Command duration styling
set -Ux tide_cmd_duration_bg_color C4A000
set -Ux tide_cmd_duration_color 000000
set -Ux tide_cmd_duration_decimals 0
set -Ux tide_cmd_duration_threshold 3000

# Vi mode styling
set -Ux tide_vi_mode_bg_color 2E3440
set -Ux tide_vi_mode_color_default D08770
set -Ux tide_vi_mode_color_insert 87CEEB
set -Ux tide_vi_mode_color_replace FF6B6B
set -Ux tide_vi_mode_icon_default DEFAULT
set -Ux tide_vi_mode_icon_insert INSERT
set -Ux tide_vi_mode_icon_replace REPLACE

set -Ux tide_prompt_transient_enabled false