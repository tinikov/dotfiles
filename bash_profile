# Login shell stays bash (POSIX for scripts); interactive shells jump to fish

[[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"

[[ -f "$HOME/.bashrc" ]] && source "$HOME/.bashrc"

if [[ $- == *i* ]] && command -v fish &> /dev/null && [[ $(ps -o comm= -p $PPID) != "fish" ]]; then
    exec fish
fi
