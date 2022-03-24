#! /bin/bash

# install vim plu
mkdir ~/.vim/
mkdir ~/.vim/plugged

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

cp .vimrc ~/

vim -c PlugInstall

# add fzf to GFiles work
brew install fzf
brew install the_silver_searcher
brew install neovim

mkdir ~/.config/nvim/
cp init.vim ~/.config/nvim/init.vim

## install rust-analyzer
nvim --cmd "CocInstall coc-rust-analyzer"
