#!/bin/bash

# Copy .vimrc to home/user
cp .vimrc ~/

# Install brew

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

# brew install git

brew install git

# Install oh my zsh

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Install powerline font
git clone https://github.com/powerline/fonts.git
cd font
/bin/bash ./install.sh
cd ..

# Clone powerlevel theme
git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k

# open download vscode

open https://code.visualstudio.com/docs/?dv=osx


# Instal nvm

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.0/install.sh | bash

nvm install v12

# Install yarn

curl -o- -L https://yarnpkg.com/install.sh | bash

# Install VTEX

# Instructions
- Install vscode
-- Open cmd+P > shell command install
