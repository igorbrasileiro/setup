#! /bin/bash

mkdir ~/.vim/
mkdir ~/.vim/plugged

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

cp .vimrc ~/

vim -c PlugInstall

# add fzf to GFiles work
brew install fzf
