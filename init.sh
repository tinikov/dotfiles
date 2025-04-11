#!/bin/bash

set -euo pipefail

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Script information
SCRIPT_NAME=$(basename "$0")
DOTFILES_DIR=$(dirname "$(realpath "${BASH_SOURCE[0]}")")

# Logging function
log() {
    local level=$1
    shift
    case $level in
        "info") echo -e "${GREEN}[INFO]${NC} $*" ;;
        "warn") echo -e "${YELLOW}[WARN]${NC} $*" ;;
        "error") echo -e "${RED}[ERROR]${NC} $*" >&2 ;;
    esac
}

# Create symlink function
create_symlink() {
    local source=$1
    local target=$2
    local backup_dir=$3

    if [[ -L "$target" ]]; then
        log "info" "Symlink already exists: $target"
        return 0
    fi

    if [[ -e "$target" ]]; then
        log "warn" "Backing up $target to $backup_dir"
        mkdir -p "$backup_dir"
        mv "$target" "$backup_dir/$(basename "$target").$(date +%Y%m%d%H%M%S)"
    fi

    log "info" "Creating symlink: $target -> $source"
    ln -sf "$source" "$target"
}

# Main function
main() {
    log "info" "Starting dotfiles setup..."

    # zsh configuration
    create_symlink "$DOTFILES_DIR/zshrc" "$HOME/.zshrc" "$HOME/.dotfiles_backup"
    create_symlink "$DOTFILES_DIR/zsh_aliases" "$HOME/.zsh_aliases" "$HOME/.dotfiles_backup"

    # Git configuration
    create_symlink "$DOTFILES_DIR/gitconfig" "$HOME/.gitconfig" "$HOME/.dotfiles_backup"

    # Starship configuration
    create_symlink "$DOTFILES_DIR/config/starship.toml" "$HOME/.config/starship.toml" "$HOME/.dotfiles_backup"

    # Neovim configuration
    if [[ ! -L "$HOME/.config/nvim/lua" ]]; then
        # Backup existing configuration (if exists)
        [[ -d "$HOME/.config/nvim" ]] && mv "$HOME/.config/nvim" "$HOME/.config/nvim.bak"
        [[ -d "$HOME/.local/share/nvim" ]] && mv "$HOME/.local/share/nvim" "$HOME/.local/share/nvim.bak"
        [[ -d "$HOME/.local/state/nvim" ]] && mv "$HOME/.local/state/nvim" "$HOME/.local/state/nvim.bak"
        [[ -d "$HOME/.cache/nvim" ]] && mv "$HOME/.cache/nvim" "$HOME/.cache/nvim.bak"

        # Clone and setup AstroNvim
        log "info" "Cloning AstroNvim template"
        git clone --depth 1 https://github.com/AstroNvim/template "$HOME/.config/nvim"
        rm -rf "$HOME/.config/nvim/.git"
        create_symlink "$DOTFILES_DIR/config/nvim/lua" "$HOME/.config/nvim/lua" "$HOME/.dotfiles_backup"
    else
        log "info" "Symlink already exists: $HOME/.config/nvim/lua"
    fi

    # Fish configuration
    create_symlink "$DOTFILES_DIR/config/fish" "$HOME/.config/fish" "$HOME/.dotfiles_backup"

    log "info" "Dotfiles setup completed!"
}

# Execute main function
main "$@"
