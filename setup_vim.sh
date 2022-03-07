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
## https://petermalmgren.com/rc-batch-day-9/
## https://rust-analyzer.github.io/manual.html#installation
mkdir -p ~/.local/bin
curl -L https://github.com/rust-analyzer/rust-analyzer/releases/download/2022-03-07/rust-analyzer-aarch64-apple-darwin.gz | gunzip -c - > ~/.local/bin/rust-analyzer
chmod +x ~/.local/bin/rust-analyzer
