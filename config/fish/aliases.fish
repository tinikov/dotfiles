# ls
alias la="ls -a"
alias l="ls -alh"

# rm
alias rm="rm -i"

# brew
if command -q brew
    alias brclean="brew cleanup --prune=all;brew autoremove"
    alias brup="brew update;brew upgrade"
end

# rust
if command -q rustup
    alias rsup="rustup update"
end

# caps lock <--> esc quick map (macOS only)
if test (uname) = Darwin
    function vmode
        sh -c "hidutil property --set '{\"UserKeyMapping\":[{\"HIDKeyboardModifierMappingSrc\":30064771129,\"HIDKeyboardModifierMappingDst\":30064771113}]}'"
    end

    function nmode
        sh -c "hidutil property --set '{\"UserKeyMapping\":[]}'"
    end
end

# Proxy settings
alias proxy-stat="env | grep -i proxy"

function proxy-on
    set -l port 7890
    set -gx https_proxy http://127.0.0.1:$port
    set -gx http_proxy http://127.0.0.1:$port
    set -gx all_proxy socks5://127.0.0.1:$port
end

function proxy-off
    set -e https_proxy
    set -e http_proxy
    set -e all_proxy
end
