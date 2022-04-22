#!/bin/bash

# Defining colors
NC='\033[0m' # No Color
GREEN='\033[0;32m'  # Green
RED='\033[0;31m'  # Red

# Install oh my zsh

echo -e "${GREEN}installing oh my zsh${NC}"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Install powerline font
if which git > /dev/null
  then
    echo -e "${GREEN}Installing powerline fonts...${NC}"
    git clone https://github.com/powerline/fonts.git
    cd ./font
    /bin/bash ./install.sh
    cd ..
  else
    echo -e "${RED} Git not installed... install git and run again ./setup_zsh.sh${NC}"
  fi

# Clone powerlevel theme
# git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k

echo -e "${GREEN}Installing powerlevel10k zsh theme...${NC}"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Installing autosuggestion
# echo "installing zsh- autosuggestion"

# git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Copy .zshrc

echo -e "${GREEN} Copying zshrc and p10k.zsh to ~/.zshrc and ~/.p10k.zsh${NC}"
cp .zshrc ~/.zshrc
cp .p10k.zsh ~/.p10k.zsh
