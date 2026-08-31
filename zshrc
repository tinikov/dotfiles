# General
export LANG=en_US.UTF-8 # Locale
export EDITOR=vim
bindkey -e  # Emacs key binding

# Use Starship prompt
command -v starship >/dev/null && eval "$(starship init zsh)"

# Auto-completion
if type brew &>/dev/null; then  # Load brew completion function
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

autoload -Uz compinit
compinit

# brew env configs
export HOMEBREW_NO_ENV_HINTS=true

# ls (GNU and BSD take different color flags)
if ls --version >/dev/null 2>&1; then # GNU
  alias ls='ls --color=auto -F'
else # BSD/macOS
  export LSCOLORS=Gxfxcxdxbxegedabagacad
  alias ls='ls -GF'
fi
alias la='ls -a'
alias ll='ls -lh'
alias l='ls -alh'

# uv
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"
