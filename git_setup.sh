git config --global user.name igorbrasileiro
git config --global user.email brasileiro456@gmail.com
git config --global alias.l1 'log --oneline'
git config --global alias.sw 'switch'
echo 'CRIANDO ~/.bash_aliases'
echo "alias gitfep='git fetch && git pull'" >> ~/.bash_aliases
echo "source ~/.bash_aliases" >> ~/.zshrc