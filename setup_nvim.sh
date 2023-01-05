brew install neovim

# Install tools for search
brew install ripgrep
brew install fd

# Install tools for mason LSP setup
brew install nvm
nvm install --lts

# Run :checkhealth at neovim

mkdir ~/.config/nvim
cp init.lua ~/.config/nvim/init.lua
