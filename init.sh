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
    log "info" "Starting initialization..."

    # Zsh configuration
    create_symlink "$DOTFILES_DIR/zshrc" "$HOME/.zshrc" "$HOME/.dotfiles_backup"
    create_symlink "$DOTFILES_DIR/zsh_aliases" "$HOME/.zsh_aliases" "$HOME/.dotfiles_backup"

    # Git configuration
    create_symlink "$DOTFILES_DIR/gitconfig" "$HOME/.gitconfig" "$HOME/.dotfiles_backup"

    # Init Homebrew
    read -p "Install homebrew? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        echo >> $HOME/.zprofile
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
        log "info" "Homebrew installation completed!"
    fi

    # Minimal brew bundle
    read -p "Minimal installation of needed apps? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        brew bundle --file="$dotfiles_dir/brewfile-minimal"
        log "info" "Brew bundle installation completed!"
    fi

    # Fish configuration
    create_symlink "$DOTFILES_DIR/config/fish" "$HOME/.config/fish" "$HOME/.dotfiles_backup"

    # Starship configuration
    create_symlink "$DOTFILES_DIR/config/starship.toml" "$HOME/.config/starship.toml" "$HOME/.dotfiles_backup"

    # Ask to install uv
    read -p "Install uv (python package manager)? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        curl -LsSf https://astral.sh/uv/install.sh | sh
        log "info" "uv installation completed!"
    fi

    # Ask to install fnm
    read -p "Install fnm (node version manager)? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        curl -fsSL https://fnm.vercel.app/install | bash
        log "info" "fnm installation completed!"
    fi

    # Ask to install rustup
    read -p "Install rustup (rust manager)? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
        log "info" "rustup installation completed!"
    fi

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

    log "info" "Initialization completed! Restart your terminal to apply changes."
}

# Execute main function
main "$@"
