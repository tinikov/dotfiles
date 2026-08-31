#!/bin/bash

set -euo pipefail

DOTFILES_DIR=$(dirname "$(realpath "${BASH_SOURCE[0]}")")
BACKUP_DIR="$HOME/.dotfiles_backup"

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log() {
    local level=$1
    shift
    case $level in
        info)  echo -e "${GREEN}[INFO]${NC} $*" ;;
        warn)  echo -e "${YELLOW}[WARN]${NC} $*" ;;
        error) echo -e "${RED}[ERROR]${NC} $*" >&2 ;;
    esac
}

# Ask a y/N question; succeeds only on y/Y
confirm() {
    local reply
    read -p "$1 (y/N) " -n 1 -r reply
    echo
    [[ $reply =~ ^[Yy]$ ]]
}

# Symlink source -> target, backing up any existing file/dir at target
create_symlink() {
    local source=$1 target=$2

    if [[ -L "$target" ]]; then
        log info "Symlink already exists: $target"
        return 0
    fi

    if [[ -e "$target" ]]; then
        log warn "Backing up $target to $BACKUP_DIR"
        mkdir -p "$BACKUP_DIR"
        mv "$target" "$BACKUP_DIR/$(basename "$target").$(date +%Y%m%d%H%M%S)"
    fi

    log info "Creating symlink: $target -> $source"
    mkdir -p "$(dirname "$target")"
    ln -s "$source" "$target"
}

# Write machine-specific git identity to ~/.gitconfig.local (included by gitconfig)
setup_git_identity() {
    local local_config="$HOME/.gitconfig.local"
    local name email

    if [[ -f "$local_config" ]]; then
        log info "Git identity already configured: $local_config"
        return 0
    fi

    read -p "Git user.name: " -r name
    read -p "Git user.email: " -r email

    if [[ -z "$name" || -z "$email" ]]; then
        log warn "Empty name or email; skipping. Rerun this script to set it up."
        return 0
    fi

    git config --file "$local_config" user.name "$name"
    git config --file "$local_config" user.email "$email"
    log info "Git identity written to $local_config"
}

install_homebrew() {
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo >> "$HOME/.zprofile"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
    eval "$(/opt/homebrew/bin/brew shellenv)"
}

main() {
    log info "Starting initialization..."

    create_symlink "$DOTFILES_DIR/zshrc" "$HOME/.zshrc"
    create_symlink "$DOTFILES_DIR/gitconfig" "$HOME/.gitconfig"
    setup_git_identity
    create_symlink "$DOTFILES_DIR/config/fish" "$HOME/.config/fish"
    create_symlink "$DOTFILES_DIR/config/starship.toml" "$HOME/.config/starship.toml"
    create_symlink "$DOTFILES_DIR/config/ghostty" "$HOME/.config/ghostty"
    create_symlink "$DOTFILES_DIR/config/nvim" "$HOME/.config/nvim"

    # Homebrew and apps: macOS only (use the distro package manager on Linux)
    if [[ "$(uname)" == "Darwin" ]]; then
        if confirm "Install homebrew?"; then
            install_homebrew
            log info "Homebrew installation completed!"
        fi

        if confirm "Minimal installation of needed apps?"; then
            brew bundle --file="$DOTFILES_DIR/Brewfile-minimal"
            log info "Brew bundle installation completed!"
        fi
    fi

    if confirm "Install uv (python package manager)?"; then
        curl -LsSf https://astral.sh/uv/install.sh | env UV_NO_MODIFY_PATH=1 sh
        log info "uv installation completed!"
    fi

    if confirm "Install rustup (rust manager)?"; then
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path
        log info "rustup installation completed!"
    fi

    log info "Initialization completed! Restart your terminal to apply changes."
}

main "$@"
