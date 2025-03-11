function fish_greeting
    set_color -o brblue
    echo "╭────────────────────────────────────────╮"
    echo "│                                        │"
    echo "│           "(set_color bryellow)"THE FUTURE IS NOW"(set_color brblue)"            │"
    echo "│                                        │"
    echo "╰────────────────────────────────────────╯"
    
    set_color green
    set_color -o
    echo "       $(date '+%Y年%m月%d日 %A %H:%M')"
    set_color normal
    
    echo
    set_color -o
    echo " aliases"
    set_color normal
    echo " ‣ capslock <-> esc:  "(set_color cyan)"vmode nmode"(set_color normal)
    echo " ‣ brew maintenance:  "(set_color cyan)"brup brclean"(set_color normal)
    echo " ‣ proxy:  "(set_color cyan)"proxy-on proxy-off proxy-stat"(set_color normal)
    echo
end
