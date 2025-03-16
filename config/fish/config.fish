eval (/opt/homebrew/bin/brew shellenv)

if status is-interactive
    # Commands to run in interactive sessions can go here
    source ~/.config/fish/aliases.fish

    set -gx EDITOR nvim
    set -gx LANG zh_CN.UTF-8
end

