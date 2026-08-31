function fish_greeting
    set_color -i -o green
    echo "$(date '+%Y-%m-%d %A %H:%M')"
    set_color normal
end
