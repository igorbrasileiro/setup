#!/bin/bash

git config --global user.name igorbrasileiro
git config --global user.email brasileiro456@gmail.com
git config --global alias.l1 'log --oneline'
git config --global alias.sw 'switch'
git config --global alias.g "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
echo 'CRIANDO ~/.bash_aliases'
echo "alias gitfep='git fetch && git pull'" >> ~/.bash_aliases
echo "source ~/.bash_aliases" >> ~/.zshrc
echo "Copying remove_merged_branchs script to home path"
cp ./remove_merged_branchs.sh ~/remove_merged_branchs.sh