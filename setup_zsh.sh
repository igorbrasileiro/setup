echo "installing oh my zsh"
# Install oh my zsh

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Install powerline font
git clone https://github.com/powerline/fonts.git
cd font
/bin/bash ./install.sh
cd ..

# Clone powerlevel theme
# git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Installing autosuggestion
echo "installing zsh- autosuggestion"

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Copy .zshrc
cp ./.zshrc ~/.zshrc
cp .p10k.zsh ~/.p10k.zsh
