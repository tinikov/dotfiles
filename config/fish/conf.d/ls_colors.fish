# LS_COLORS is set here, not inherited from bash: RHEL's /etc/profile.d/colorls.sh picks
# a palette by $TERM, so ls looked different inside and outside tmux.
# Dayfox (Ghostty theme) colors as true color: 38;2;R;G;B foreground, 48;2;R;G;B background.
# Only GNU ls reads LS_COLORS: gls (coreutils) on macOS, the system ls on Linux.
if status is-interactive
    set -l blue '38;2;40;72;169' # #2848a9
    set -l cyan '38;2;40;121;128' # #287980
    set -l green '38;2;57;104;71' # #396847
    set -l orange '38;2;172;84;2' # #ac5402
    set -l red '38;2;165;34;47' # #a5222f
    set -l magenta '38;2;110;51;206' # #6e33ce
    set -l bg_blue '48;2;217;226;245' # #d9e2f5
    set -l bg_rose '48;2;245;217;220' # #f5d9dc
    set -l bg_peach '48;2;243;225;205' # #f3e1cd

    set -l c \
        rs=0 mh=0 ca=0 \
        "di=1;$blue" \
        "ln=$cyan" \
        "or=$red" "mi=$red" \
        "ex=1;$green" \
        "pi=$orange" "bd=1;$orange" "cd=1;$orange" \
        "so=$magenta" "do=$magenta" \
        "su=$red;$bg_rose" "sg=$orange;$bg_peach" \
        "tw=$blue;$bg_blue" "ow=$blue;$bg_blue" "st=$blue;$bg_blue"
    for ext in tar tgz gz xz bz2 zst zip 7z rar
        set -a c "*.$ext=$red"
    end
    for ext in png jpg jpeg gif svg webp pdf
        set -a c "*.$ext=$magenta"
    end
    set -gx LS_COLORS (string join : $c)

    # macOS: BSD ls ignores LS_COLORS, so use gls when coreutils is installed.
    # Same flags fish's own ls wrapper adds (-F only when writing to a terminal).
    if command -q gls
        function ls --wraps=gls --description 'GNU ls with LS_COLORS'
            set -l opt --color=auto
            isatty stdout; and set -a opt -F
            command gls $opt $argv
        end
    end
end
