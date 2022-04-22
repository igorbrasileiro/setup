#!/bin/bash

# Color bash text definition
# https://stackoverflow.com/a/28938235

NC='\033[0m' # No Color
GREEN='\033[0;32m'  # Green
RED='\033[0;31m'  # Red

# Install brew

echo -e "${GREEN}Installing Brew...${NC}"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

# installing git

echo -e "${GREEN}Installing Git using Brew...${NC}"
brew install git
brew install gh

# Instal nvm

echo -e "${GREEN}Installing nvm, node LTS and yarn...${NC}"
brew install nvm
nvm install --lts
brew install yarn
# curl -o- -L https://yarnpkg.com/install.sh | bash

# installing and setting up Oh My Zsh

echo -e "${GREEN}Running setup_zsh.sh...${NC}"
./setup_zsh.sh

# installing and setting up vim


if which yarn > /dev/null
  then
    echo -e "${GREEN}Running setup_vim.sh...${NC}"
    ./setup_vim.sh
  else
    echo "${RED}Yarn not installed... Run ./setup_vim.sh manually${NC}"
  fi

# open download vscode

# open https://code.visualstudio.com/docs/?dv=osx

# Instructions
# - Install vscode
# -- Open cmd+P > shell command install
