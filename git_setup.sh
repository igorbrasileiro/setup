#!/bin/bash

git config --global user.name igorbrasileiro
git config --global user.email brasileiro456@gmail.com
git config --global core.editor nvim
git config --global alias.l1 'log --oneline'
git config --global alias.sw 'switch'
git config --global alias.lg "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all"

echo 'CRIANDO ~/.bash_aliases'
cp ./.bash_aliases ~/.bash_aliases
echo 'Adding bash_aliases to ~/.zshrc'
echo "source ~/.bash_aliases" >> ~/.zshrc

echo "Copying remove_merged_branchs script to home path"
cp ./remove_merged_branchs.sh ~/remove_merged_branchs.sh
