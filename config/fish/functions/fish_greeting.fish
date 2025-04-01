function fish_greeting
    # set_color -o brblue
    # echo "╭────────────────────────────────────────╮"
    # echo "│                                        │"
    # echo "│           "(set_color bryellow)"THE FUTURE IS NOW"(set_color brblue)"            │"
    # echo "│                                        │"
    # echo "╰────────────────────────────────────────╯"
    # set_color -o
    # echo "       $(date '+%Y年%m月%d日 %A %H:%M')"
    
    set_color -io green
    echo "$(date '+%Y-%m-%d %A %H:%M')"
    set_color normal
    set_color -i bryellow
    echo "  \"THE FUTURE IS NOW\""
    set_color normal
    set_color -io
    echo " Aliases"
    set_color normal
    echo " ‣ capslock <-> esc:  "(set_color -io cyan)"vmode nmode"(set_color normal)
    echo " ‣ brew maintenance:  "(set_color -io cyan)"brup brclean"(set_color normal)
    echo " ‣ proxy:  "(set_color -io cyan)"proxy-on proxy-off proxy-stat"(set_color normal)
    set_color normal
    echo
end
