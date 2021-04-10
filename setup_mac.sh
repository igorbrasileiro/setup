#!/bin/bash

# Install brew

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

# installing git

brew install git

# installing and setting up Oh My Zsh
./setup_zsh.sh

# open download vscode

open https://code.visualstudio.com/docs/?dv=osx


# Instal nvm

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.0/install.sh | bash

nvm install latest

# Install yarn

curl -o- -L https://yarnpkg.com/install.sh | bash

# Install VTEX

# Instructions
- Install vscode
-- Open cmd+P > shell command install

# Copy .vimrc to home/user
./setup_vim.sh

