#! /bin/bash

# Color bash text definition
# https://stackoverflow.com/a/28938235

NC='\033[0m' # No Color
GREEN='\033[0;32m'  # Green
RED='\033[0;31m'  # Red

# install vim plug
echo -e "${GREEN}Installing vim plug...${NC}"
mkdir ~/.vim/
mkdir ~/.vim/plugged

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

cp .vimrc ~/

vim -c PlugInstall

# add fzf to GFiles work
echo -e "${GREEN}Installing fzf, the search silver and neovim...${NC}"
brew install fzf
brew install the_silver_searcher
brew install neovim

# Copying vim settings to nvim
echo -e "${GREEN}Copying init.vim setup to neovim...${NC}"
mkdir ~/.config/nvim/
cp init.vim ~/.config/nvim/init.vim

## install rust-analyzer

echo -e "${GREEN}Instaling coc-rust-analyizer...${NC}"
nvim --cmd "CocInstall coc-rust-analyzer"
