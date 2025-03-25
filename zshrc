# General
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=10000
setopt autocd beep nomatch correct_all
setopt share_history  # Sync history immediately
unsetopt notify
bindkey -e  # Emacs key binding

# export LANG=zh_CN.UTF-8  # Locale
export LANG=en_US.UTF-8 # Locale
export EDITOR=nvim

# Use Starship prompt
## brew install starship first
# eval "$(starship init zsh)"

# Auto-completion
zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' menu select=2
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle :compinstall filename '/Users/tinikov/.zshrc'

if type brew &>/dev/null; then  # Load brew completion function
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

autoload -Uz compinit
compinit

# zsh plugins
## brew install zsh-autosuggestions first
# . $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# export zsh_autosuggest_strategy=(match_prev_cmd completion)

## brew install zsh-syntax-highlighting first
# . $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# brew env configs
export HOMEBREW_NO_ENV_HINTS=true

# python env
export virtual_env_disable_prompt=1

# Load aliases
. ~/.zsh_aliases
