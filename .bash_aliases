alias gitfep='git fetch && git pull origin $(git branch --show-current)'

faststore_link() {
  rm -rf "./node_modules/@faststore/$1" && cp -r "$HOME/dev/vtex/faststore/packages/$1" "./node_modules/@faststore/";
}
alias flink=faststore_link

alias nvim='~/nvim.appimage'
