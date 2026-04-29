function fish_greeting
    set_color -i -o green
    echo "$(date '+%Y-%m-%d %A %H:%M')"
    set_color normal
    # set_color -i bryellow
    # echo "  \"THE FUTURE IS NOW\""
    # set_color normal
    # set_color -i -o
    # echo " Aliases"
    # set_color normal
    # echo " ‣ capslock <-> esc:  "(set_color -i -o cyan)"vmode nmode"(set_color normal)
    # echo " ‣ brew maintenance:  "(set_color -i -o cyan)"brup brclean"(set_color normal)
    # echo " ‣ proxy:  "(set_color -i -o cyan)"proxy-(on/off/stat/test)"(set_color normal)
    # set_color normal
    # echo
end
