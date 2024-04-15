#!/bin/bash

# motd
echo -e "\nLinking to /etc/motd needs root permission..."
sudo ln -sf ~/dotfiles/motd /etc/motd

# zshrc
ln -sf ~/dotfiles/zshrc ~/.zshrc

# Brewfile
ln -sf ~/dotfiles/Brewfile ~/Brewfile

# GitHub
ln -sf ~/dotfiles/gitconfig ~/.gitconfig

# pip
ln -sf ~/dotfiles/pybase-req.txt ~/pybase-req

# .config
## nvim
if [[ -d ~/.config/nvim ]]; then
	mv ~/.config/nvim ~/.config/nvim.bak
	ln -sf ~/dotfiles/config/nvim ~/.config/nvim
elif [[ -L ~/.config/nvim ]]; then
	rm -f ~/.config/nvim
	ln -sf ~/dotfiles/config/nvim ~/.config/nvim
else
	ln -sf ~/dotfiles/config/nvim ~/.config/nvim
fi

## broot
if [[ -d ~/.config/broot ]]; then
	ln -sf ~/dotfiles/config/broot/conf.hjson ~/.config/broot/conf.hjson
else
	echo -e "\nBroot not installed!"
fi
