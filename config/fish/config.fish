# Environment variables (PATH, EDITOR, LANG, ...) come from ~/.bash_profile:
# every interactive session starts as a login bash that execs fish.

if status is-interactive
    source $__fish_config_dir/aliases.fish

    if command -q starship
        starship init fish | source
    end
end

# Machine-local config, kept outside the repo (template: examples/fish.local.fish)
if test -f ~/.config/fish.local.fish
    source ~/.config/fish.local.fish
end
