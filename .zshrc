# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Use a minimal OMZ theme; powerlevel10k is loaded via zplug below.
ZSH_THEME="robbyrussell"

plugins=(git)

source $ZSH/oh-my-zsh.sh

# Shared aliases
[[ -f "$HOME/.bash_aliases" ]] && source "$HOME/.bash_aliases"

# zplug plugins and theme
if [[ -f "$HOME/.zplug/init.zsh" ]]; then
  source "$HOME/.zplug/init.zsh"

  zplug "b4b4r07/enhancd", use:init.sh
  zplug "junegunn/fzf", use:"shell/*.zsh"
  zplug "zsh-users/zsh-syntax-highlighting", defer:2
  zplug romkatv/powerlevel10k, as:theme, depth:1

  zplug load

  export ENHANCD_FILTER=fzf
fi

# Powerlevel10k prompt
if [[ -f "$HOME/.p10k.zsh" ]]; then
  source "$HOME/.p10k.zsh"
elif [[ -f "$HOME/p10k.zsh" ]]; then
  source "$HOME/p10k.zsh"
fi
POWERLEVEL9K_SHORTEN_STRATEGY="truncate_from_right"

# nvm (Homebrew install path; setup_homebrew.sh also appends these lines)
export NVM_DIR="$HOME/.nvm"
if [[ -s "/opt/homebrew/opt/nvm/nvm.sh" ]]; then
  . "/opt/homebrew/opt/nvm/nvm.sh"
  . "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
elif [[ -s "$NVM_DIR/nvm.sh" ]]; then
  . "$NVM_DIR/nvm.sh"
  [[ -s "$NVM_DIR/bash_completion" ]] && . "$NVM_DIR/bash_completion"
fi

# Yarn global binaries
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# Machine-specific overrides (API keys, extra PATH entries, etc.)
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
