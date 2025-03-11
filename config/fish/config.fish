if status is-interactive
    # Commands to run in interactive sessions can go here
    function zsh
        env ZSH_FULL_CONFIG=1 zsh
    end
    
    if test -f ~/.config/fish/aliases.fish
        source ~/.config/fish/aliases.fish
    end
end

