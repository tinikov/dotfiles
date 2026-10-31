#!/bin/bash
# Bootstrap these dotfiles on macOS or Linux.
# Configs are symlinked (existing files are backed up); every install asks first.
# `source init.sh` only loads the functions, so an agent can run single steps;
# source it in a subshell (bash -c '...'), since the functions assume `set -euo pipefail`.

DOTFILES_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)
BACKUP_DIR="$HOME/.dotfiles_backup"
LOCAL_BIN="$HOME/.local/bin"
OS=$(uname -s)

# Machine-local files, kept outside the repo (templates in examples/)
FISH_LOCAL="$HOME/.config/fish.local.fish"
GIT_LOCAL="$HOME/.gitconfig.local"

# Static single-file builds for Linux machines without root or with an old glibc
# (musl builds; fish 4 ships its own static build). Bump versions here.
FISH_VERSION=4.9.3
RG_VERSION=15.2.0
FD_VERSION=10.5.0
BAT_VERSION=0.26.1

# Oldest fish the configs work with (`command -q` needs 3.1)
FISH_MIN_VERSION=3.1

# Command-line tools the configs expect on Linux (macOS gets its set from Brewfile)
LINUX_TOOLS=(git fish tmux rg fd bat)

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

# Ask a y/N question; succeeds only on y/Y (and fails without a terminal)
confirm() {
    local reply
    read -p "$1 (y/N) " -n 1 -r reply || return 1
    echo
    [[ $reply =~ ^[Yy]$ ]]
}

# Symlink source -> target. Anything else at target (file, dir, or a link pointing
# elsewhere) is moved to BACKUP_DIR first.
create_symlink() {
    local source=$1 target=$2 name

    if [[ -L "$target" && $(readlink "$target") == "$source" ]]; then
        log info "Already linked: $target"
        return 0
    fi

    if [[ -e "$target" || -L "$target" ]]; then
        name=${target##*/}
        mkdir -p "$BACKUP_DIR"
        log warn "Backing up $target to $BACKUP_DIR"
        mv "$target" "$BACKUP_DIR/${name#.}.$(date +%Y%m%d%H%M%S)"
    fi

    log info "Creating symlink: $target -> $source"
    mkdir -p "$(dirname "$target")"
    ln -s "$source" "$target"
}

# Write machine-specific git identity to ~/.gitconfig.local (included by gitconfig)
setup_git_identity() {
    local name email

    if [[ -f "$GIT_LOCAL" ]]; then
        log info "Git identity already configured: $GIT_LOCAL"
        return 0
    fi
    if ! command -v git &> /dev/null; then
        log warn "git not installed; skipping git identity. Rerun this script after installing git."
        return 0
    fi
    if [[ ! -t 0 ]]; then
        log warn "No terminal; skipping git identity. See examples/gitconfig.local."
        return 0
    fi

    read -p "Git user.name: " -r name
    read -p "Git user.email: " -r email

    if [[ -z "$name" || -z "$email" ]]; then
        log warn "Empty name or email; skipping. Rerun this script to set it up."
        return 0
    fi

    git config --file "$GIT_LOCAL" user.name "$name"
    git config --file "$GIT_LOCAL" user.email "$email"
    log info "Git identity written to $GIT_LOCAL"
}

# Before ~/.config/fish becomes a link into the repo: move its machine-local config
# out of the way, keep fish's own state, and point out anything left behind
migrate_fish_local() {
    local old="$HOME/.config/fish" repo="$DOTFILES_DIR/config/fish" f

    # local.fish used to live inside the fish dir (old layout of this repo, or a
    # hand-made config on a server)
    for f in "$repo/local.fish" "$old/local.fish"; do
        [[ -f "$f" ]] || continue
        if [[ -e "$FISH_LOCAL" ]]; then
            log warn "Both $f and $FISH_LOCAL exist; merge them by hand"
        else
            log info "Moving $f to $FISH_LOCAL"
            mv "$f" "$FISH_LOCAL"
        fi
    done

    [[ -d "$old" && ! -L "$old" ]] || return 0

    # Universal variables are fish state, not config; keep them for this machine
    if [[ -f "$old/fish_variables" && ! -e "$repo/fish_variables" ]]; then
        cp "$old/fish_variables" "$repo/fish_variables"
    fi
    for f in "$old"/functions/*.fish "$old"/completions/*.fish "$old"/conf.d/*.fish; do
        [[ -e "$f" ]] && log warn "Not carried over (stays in the backup): ${f#"$old"/}"
    done
    return 0
}

# Pure linking, no prompts: safe to call on its own
link_configs() {
    create_symlink "$DOTFILES_DIR/bash_profile" "$HOME/.bash_profile"
    create_symlink "$DOTFILES_DIR/gitconfig" "$HOME/.gitconfig"
    migrate_fish_local
    create_symlink "$DOTFILES_DIR/config/fish" "$HOME/.config/fish"
    create_symlink "$DOTFILES_DIR/config/starship.toml" "$HOME/.config/starship.toml"
    # tmux < 3.1 only reads ~/.tmux.conf
    create_symlink "$DOTFILES_DIR/config/tmux/tmux.conf" "$HOME/.tmux.conf"
    create_symlink "$DOTFILES_DIR/vimrc" "$HOME/.vimrc"

    if [[ $OS == Darwin ]]; then
        create_symlink "$DOTFILES_DIR/config/ghostty" "$HOME/.config/ghostty"
        create_symlink "$DOTFILES_DIR/config/nvim" "$HOME/.config/nvim"
    fi
}

# ---------- macOS ----------

# macOS defaults to zsh; the login shell has to be bash so ~/.bash_profile runs
# and hands over to fish. Use brew's bash rather than the 3.2 in /bin.
setup_brew_bash() {
    local brew_bash current_shell
    brew_bash="$(brew --prefix)/bin/bash"

    current_shell=$(dscl . -read "/Users/$USER" UserShell | awk '{print $2}')
    if [[ "$current_shell" == "$brew_bash" ]]; then
        log info "Login shell is already $brew_bash"
        return 0
    fi
    if [[ ! -x "$brew_bash" ]]; then
        log warn "$brew_bash not installed (it is in Brewfile); skipping login shell setup"
        return 0
    fi
    if ! confirm "Make $brew_bash the login shell (edits /etc/shells with sudo, runs chsh)?"; then
        return 0
    fi

    if ! grep -qx "$brew_bash" /etc/shells; then
        echo "$brew_bash" | sudo tee -a /etc/shells > /dev/null
    fi
    chsh -s "$brew_bash"
    log info "Login shell changed to $brew_bash"
}

install_homebrew() {
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # ~/.bash_profile runs `brew shellenv` from now on
    eval "$(/opt/homebrew/bin/brew shellenv)"
}

setup_macos() {
    if ! command -v brew &> /dev/null && confirm "Install homebrew?"; then
        install_homebrew
        log info "Homebrew installation completed!"
    fi

    if ! command -v brew &> /dev/null; then
        log warn "Homebrew not found; skipping apps and login shell setup"
        return 0
    fi

    if confirm "Install the base apps (Brewfile)?"; then
        brew bundle --file="$DOTFILES_DIR/Brewfile"
    fi
    if confirm "Install the extra apps (Brewfile.extra)?"; then
        brew bundle --file="$DOTFILES_DIR/Brewfile.extra"
    fi

    setup_brew_bash
}

# ---------- Linux ----------

# A fish older than FISH_MIN_VERSION counts as missing
fish_too_old() {
    local version
    version=$(fish --version 2> /dev/null | awk '{print $NF}')
    [[ $(printf '%s\n' "$FISH_MIN_VERSION" "$version" | sort -V | head -n 1) != "$FISH_MIN_VERSION" ]]
}

missing_linux_tools() {
    local t
    for t in "${LINUX_TOOLS[@]}"; do
        if ! command -v "$t" &> /dev/null; then
            echo "$t"
        elif [[ $t == fish ]] && fish_too_old; then
            log warn "fish $(fish --version | awk '{print $NF}') is older than $FISH_MIN_VERSION" >&2
            echo fish
        fi
    done
}

detect_package_manager() {
    local pm
    for pm in apt-get dnf yum pacman zypper; do
        if command -v "$pm" &> /dev/null; then
            echo "$pm"
            return 0
        fi
    done
}

# Command name -> package name
package_name() {
    local pm=$1 tool=$2
    case $tool in
        rg) echo ripgrep ;;
        fd) [[ $pm == apt-get || $pm == dnf || $pm == yum ]] && echo fd-find || echo fd ;;
        *)  echo "$tool" ;;
    esac
}

install_with_package_manager() {
    local pm=$1 t
    shift
    local -a pkgs=()
    for t in "$@"; do
        pkgs+=("$(package_name "$pm" "$t")")
    done

    case $pm in
        apt-get) sudo apt-get update && sudo apt-get install -y "${pkgs[@]}" ;;
        dnf|yum) sudo "$pm" install -y "${pkgs[@]}" ;;
        pacman)  sudo pacman -S --needed --noconfirm "${pkgs[@]}" ;;
        zypper)  sudo zypper install -y "${pkgs[@]}" ;;
    esac
}

# Debian/Ubuntu install fd and bat as fdfind and batcat
link_debian_names() {
    local name alt
    mkdir -p "$LOCAL_BIN"
    for name in fd bat; do
        alt=$([[ $name == fd ]] && echo fdfind || echo batcat)
        if ! command -v "$name" &> /dev/null && command -v "$alt" &> /dev/null; then
            log info "Linking $alt as $LOCAL_BIN/$name"
            ln -sf "$(command -v "$alt")" "$LOCAL_BIN/$name"
        fi
    done
}

# Download a static build into ~/.local/bin (no root needed, independent of glibc)
install_static_tool() {
    local tool=$1 arch url tmp archive bin
    arch=$(uname -m)
    if [[ $arch != x86_64 && $arch != aarch64 ]]; then
        log warn "No static build of $tool for $arch; skipping"
        return 0
    fi

    case $tool in
        fish) url="https://github.com/fish-shell/fish-shell/releases/download/$FISH_VERSION/fish-$FISH_VERSION-linux-$arch.tar.xz" ;;
        rg)   url="https://github.com/BurntSushi/ripgrep/releases/download/$RG_VERSION/ripgrep-$RG_VERSION-$arch-unknown-linux-musl.tar.gz" ;;
        fd)   url="https://github.com/sharkdp/fd/releases/download/v$FD_VERSION/fd-v$FD_VERSION-$arch-unknown-linux-musl.tar.gz" ;;
        bat)  url="https://github.com/sharkdp/bat/releases/download/v$BAT_VERSION/bat-v$BAT_VERSION-$arch-unknown-linux-musl.tar.gz" ;;
        *)
            log warn "No static build configured for $tool; use the system package or ask the admin"
            return 0
            ;;
    esac

    mkdir -p "$LOCAL_BIN"
    tmp=$(mktemp -d)
    archive="$tmp/${url##*/}"
    log info "Downloading $url"
    if ! curl -fsSL -o "$archive" "$url" || ! tar -xf "$archive" -C "$tmp"; then
        log error "Download or extraction of $tool failed"
        rm -rf "$tmp"
        return 1
    fi
    bin=$(find "$tmp" -type f -name "$tool" -print -quit)
    if [[ -z $bin ]] || ! install -m 755 "$bin" "$LOCAL_BIN/$tool"; then
        log error "Could not install $tool from ${url##*/}"
        rm -rf "$tmp"
        return 1
    fi
    rm -rf "$tmp"
    log info "Installed $LOCAL_BIN/$tool"
}

setup_linux_tools() {
    local pm t
    local -a missing

    mkdir -p "$LOCAL_BIN"
    export PATH="$LOCAL_BIN:$PATH"
    link_debian_names

    mapfile -t missing < <(missing_linux_tools)
    if (( ${#missing[@]} == 0 )); then
        log info "Already installed: ${LINUX_TOOLS[*]}"
        return 0
    fi
    log info "Missing tools: ${missing[*]}"

    # Normal machine: one package-manager install
    pm=$(detect_package_manager)
    if [[ -n $pm ]] && command -v sudo &> /dev/null \
        && confirm "Install ${missing[*]} with 'sudo $pm' (needs root)?"; then
        if install_with_package_manager "$pm" "${missing[@]}"; then
            link_debian_names
        else
            log warn "Package install failed (RHEL-like systems need EPEL for fish/ripgrep/fd/bat)"
        fi
        mapfile -t missing < <(missing_linux_tools)
        if (( ${#missing[@]} == 0 )); then
            return 0
        fi
    fi

    # No root / old distro: static builds into ~/.local/bin, one confirmation each
    for t in "${missing[@]}"; do
        case $t in
            git|tmux) log warn "$t has no static build here; use the system package or ask the admin" ;;
            *) if confirm "Download static $t into $LOCAL_BIN?"; then install_static_tool "$t"; fi ;;
        esac
    done
}

# Ghostty sets TERM=xterm-ghostty, which older servers don't know. Check it explicitly:
# over a non-interactive ssh command TERM is "dumb" and says nothing.
check_terminfo() {
    local term
    local -a terms=(xterm-ghostty)
    if [[ -n ${TERM:-} && $TERM != dumb && $TERM != xterm-ghostty ]]; then
        terms+=("$TERM")
    fi
    for term in "${terms[@]}"; do
        if ! infocmp "$term" &> /dev/null; then
            log warn "No terminfo for $term. On the Mac run: infocmp -x $term | ssh <host> -- tic -x -"
        fi
    done
}

# AstroNvim pulls ~45 plugins on first start: slow on network filesystems, heavy on small quotas
link_nvim_on_linux() {
    if command -v nvim &> /dev/null && confirm "nvim found. Link the AstroNvim config?"; then
        create_symlink "$DOTFILES_DIR/config/nvim" "$HOME/.config/nvim"
    fi
}

setup_linux() {
    setup_linux_tools
    link_nvim_on_linux
    check_terminfo
    log info "Login shell stays bash; ~/.bash_profile switches interactive sessions to fish (no chsh needed)"
}

# ---------- Both ----------

setup_optional_tools() {
    if [[ ! -x "$LOCAL_BIN/uv" ]] && confirm "Install uv (python package manager)?"; then
        curl -LsSf https://astral.sh/uv/install.sh | env UV_NO_MODIFY_PATH=1 sh
        log info "uv installation completed!"
    fi

    if [[ ! -x "$HOME/.cargo/bin/rustup" ]] && confirm "Install rustup (rust manager)?"; then
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path
        log info "rustup installation completed!"
    fi
}

main() {
    log info "Starting initialization ($OS)..."

    link_configs

    case $OS in
        Darwin) setup_macos ;;
        Linux)  setup_linux ;;
        *)      log warn "Unsupported OS $OS: configs linked, nothing installed" ;;
    esac

    # After the installs, so a fresh Linux box has git by now
    setup_git_identity
    setup_optional_tools

    log info "Initialization completed! Restart your terminal to apply changes."
    log info "Machine-local settings: see examples/ for ~/.bashrc, $FISH_LOCAL and $GIT_LOCAL"
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    set -euo pipefail
    main "$@"
fi
