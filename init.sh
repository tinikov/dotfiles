#!/bin/bash

# zshrc
ln -sf ~/dotfiles/zshrc ~/.zshrc
ln -sf ~/dotfiles/zsh_aliases ~/.zsh_aliases

# GitHub
ln -sf ~/dotfiles/gitconfig ~/.gitconfig

# .config
## nvim
if [[ -L ~/.config/nvim/lua ]]; then
	echo "Nvim config already linked!"
elif [[ -d ~/.config/nvim/lua ]]; then
	rm -rf ~/.config/nvim/lua
	mv ~/.local/share/nvim ~/.local/share/nvim.bak
	mv ~/.local/state/nvim ~/.local/state/nvim.bak
	mv ~/.cache/nvim ~/.cache/nvim.bak
	ln -sf ~/dotfiles/config/nvim/lua ~/.config/nvim/lua
else
	git clone --depth 1 https://github.com/AstroNvim/template ~/.config/nvim
	rm -rf ~/.config/nvim/.git
	rm -rf ~/.config/nvim/lua
	mv ~/.local/share/nvim ~/.local/share/nvim.bak
	mv ~/.local/state/nvim ~/.local/state/nvim.bak
	mv ~/.cache/nvim ~/.cache/nvim.bak
	ln -sf ~/dotfiles/config/nvim/lua ~/.config/nvim/lua
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
