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

# python
VENV_NAME="pybase"
if [[ -d ~/.$VENV_NAME ]]; then
	ln -sf ~/dotfiles/$VENV_NAME/bin/activate ~/.$VENV_NAME/bin/activate
else
	echo -e "\nVenv at ~/.$VENV_NAME not found!"
fi

# .config
## nvim
ln -sf ~/dotfiles/config/nvim ~/.config/nvim

## broot
if [[ -d ~/.config/broot ]]; then
	ln -sf ~/dotfiles/config/broot/conf.hjson ~/.config/broot/conf.hjson
else
	echo -e "\nBroot not installed!"
fi
