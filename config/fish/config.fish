if test -x /opt/homebrew/bin/brew
    eval (/opt/homebrew/bin/brew shellenv)
end

if status is-interactive
    # Commands to run in interactive sessions can go here
    source ~/.config/fish/aliases.fish

    set -gx EDITOR nvim
    set -gx LANG en_US.UTF-8
    set -gx HOMEBREW_NO_ENV_HINTS 1

    if type -q starship
        starship init fish | source
    end
end

# Machine-local config (untracked, see .gitignore)
if test -f ~/.config/fish/local.fish
    source ~/.config/fish/local.fish
end
