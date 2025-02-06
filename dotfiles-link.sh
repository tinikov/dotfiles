#!/bin/bash

# motd
echo -e "\nLinking to /etc/motd needs root permission..."
sudo ln -sf ~/dotfiles/motd /etc/motd

# zshrc
ln -sf ~/dotfiles/zshrc ~/.zshrc
ln -sf ~/dotfiles/zsh_aliases ~/.zsh_aliases

# Brewfile
ln -sf ~/dotfiles/Brewfile ~/Brewfile

# GitHub
ln -sf ~/dotfiles/gitconfig ~/.gitconfig

# pip
ln -sf ~/dotfiles/pybase-req.txt ~/pybase-req

# plist
ln -sf ~/dotfiles/brew-maintenance.sh ~/brew-maintenance

# .config
## nvim
if [[ -L ~/.config/nvim ]]; then
	echo -e "\nNvim config already linked!"
elif [[ -d ~/.config/nvim ]]; then
	mv ~/.config/nvim ~/.config/nvim.bak
	ln -sf ~/dotfiles/config/nvim ~/.config/nvim
else
	ln -sf ~/dotfiles/config/nvim ~/.config/nvim
fi
