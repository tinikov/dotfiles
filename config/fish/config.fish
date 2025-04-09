eval (/opt/homebrew/bin/brew shellenv)
source "$HOME/.cargo/env.fish"

if status is-interactive
    # Commands to run in interactive sessions can go here
    source ~/.config/fish/aliases.fish

    set -gx EDITOR nvim
    set -gx LANG en_US.UTF-8
    set -gx HOMEBREW_NO_ENV_HINTS 1

    starship init fish | source
end

