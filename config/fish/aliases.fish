# ls
alias la='ls -a'
alias l='ls -alh'
alias rm="rm -i"

# brew
alias brclean="brew cleanup --prune=all;brew autoremove"
alias brup="brew update;brew upgrade"

# python
alias python=python3
alias pip=pip3

# caps lock <--> esc quick map
function vmode
  sh -c "hidutil property --set '{\"UserKeyMapping\":[{\"HIDKeyboardModifierMappingSrc\":30064771129,\"HIDKeyboardModifierMappingDst\":30064771113}]}'"
end

function nmode
  sh -c "hidutil property --set '{\"UserKeyMapping\":[]}'"
end

# Proxy settings
alias proxy-stat="env | grep -i proxy"

function proxy-on
  set -l port 7890
  set -xg https_proxy http://127.0.0.1:$port
  set -xg http_proxy http://127.0.0.1:$port
  set -xg all_proxy socks5://127.0.0.1:$port
end

function proxy-off
  set -e https_proxy
  set -e http_proxy
  set -e all_proxy
end

