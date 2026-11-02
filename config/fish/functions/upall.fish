function upall --description 'Update brew, uv (+ Pythons, tools, completions), rustup and static builds'
    if command -q brew
        echo '==> brew'
        brew update; and brew upgrade
    end

    if command -q uv
        echo
        echo '==> uv'
        uv self update
        uv python upgrade
        uv tool upgrade --all
        # Generated here rather than at every shell start (that cost ~45 ms per start).
        # Gitignored; fish's own dir because older fish skips ~/.local/share/fish.
        set -l dir $__fish_config_dir/completions
        mkdir -p $dir
        uv generate-shell-completion fish >$dir/uv.fish
        uvx --generate-shell-completion fish >$dir/uvx.fish
    end

    # Updates the toolchains and rustup itself
    if command -q rustup
        echo
        echo '==> rustup'
        rustup update
    end

    # Static builds init.sh put into ~/.local/bin (Linux without root). Versions are
    # pinned in init.sh, so git pull first; system packages are left to the admin.
    set -l init (string replace -r '/config/fish$' '' -- (realpath $__fish_config_dir))/init.sh
    if test (uname) = Linux; and test -f $init
        echo
        echo '==> static builds'
        bash -c 'set -euo pipefail; source "$1"; update_static_tools' bash $init
    end
end
