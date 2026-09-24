export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="agnoster"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

if [ -s "$ZSH/oh-my-zsh.sh" ]; then
  source "$ZSH/oh-my-zsh.sh"
fi

if [[ $ZSH_THEME == agnoster ]] && (( $+functions[prompt_segment] )); then
  # Disable the prompt context
  prompt_context(){}

  # Agnoster calls prompt_status first; keep its status symbols after the time.
  functions -c prompt_status agnoster_prompt_status
  prompt_status() {
    prompt_segment black white "$(date +%H:%M)"
    agnoster_prompt_status
  }

  # Separate each command from the next prompt, then put input on its own line.
  PROMPT=$'\n''%{%f%b%k%}$(build_prompt)'$'\n''❯ '
fi

# Add custom paths to the PATH environment variable
case ":$PATH:" in
  *":$HOME/lib:"*) ;;
  *) export PATH="$HOME/lib:$PATH" ;;
esac

# Load environment variables from the local bin directory
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

# Enable vi mode in the shell
set -o vi

# Node Version Manager (NVM) setup
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

# PNPM setup
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
