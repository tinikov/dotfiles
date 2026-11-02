# rm
alias rm="rm -i"

# brew
if command -q brew
    alias brclean="brew cleanup --prune=all;brew autoremove"
end
