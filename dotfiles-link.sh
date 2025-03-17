#!/bin/bash

# zshrc
ln -sf ~/dotfiles/zshrc ~/.zshrc
ln -sf ~/dotfiles/zsh_aliases ~/.zsh_aliases

# Brewfile
# ln -sf ~/dotfiles/Brewfile ~/Brewfile

# GitHub
ln -sf ~/dotfiles/gitconfig ~/.gitconfig

# pip
# ln -sf ~/dotfiles/pybase-req.txt ~/pybase-req

# .config
## nvim
if [[ -L ~/.config/nvim ]]; then
	echo "Nvim config already linked!"
elif [[ -d ~/.config/nvim ]]; then
	mv ~/.config/nvim ~/.config/nvim.bak
	ln -sf ~/dotfiles/config/nvim ~/.config/nvim
else
	ln -sf ~/dotfiles/config/nvim ~/.config/nvim
fi

## fish
if [[ -L ~/.config/fish ]]; then
	echo "Fish config already linked!"
elif [[ -d ~/.config/fish ]]; then
	mv ~/.config/fish ~/.config/fish.bak
	ln -sf ~/dotfiles/config/fish ~/.config/fish
else
	ln -sf ~/dotfiles/config/fish ~/.config/fish
fi
echo
