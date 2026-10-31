# The login shell is bash on every machine (POSIX for scripts; HPC module/job tooling
# expects it). It sets up the environment for all shells, then interactive sessions
# switch to fish, so no chsh to fish is needed (works without root).

# ---------- PATH ----------
if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    export HOMEBREW_NO_ENV_HINTS=1
fi
[[ -d "$HOME/.cargo/bin" && ":$PATH:" != *":$HOME/.cargo/bin:"* ]] && PATH="$HOME/.cargo/bin:$PATH"
# Last, so it comes first: static builds on machines without root, uv, claude
[[ -d "$HOME/.local/bin" && ":$PATH:" != *":$HOME/.local/bin:"* ]] && PATH="$HOME/.local/bin:$PATH"
export PATH

# ---------- Environment ----------
if command -v nvim &> /dev/null; then
    export EDITOR=nvim
else
    export EDITOR=vim
fi

# Minimal Linux images often lack en_US.UTF-8 (Debian cloud images only have C.UTF-8)
if locale -a 2> /dev/null | grep -qiE '^en_US\.utf-?8$'; then
    export LANG=en_US.UTF-8
elif locale -a 2> /dev/null | grep -qiE '^C\.utf-?8$'; then
    export LANG=C.UTF-8
fi

# Machine-local settings (Linux: /etc/bashrc, module loads, ...); see examples/bashrc
[[ -f "$HOME/.bashrc" ]] && source "$HOME/.bashrc"

# Interactive only, not `bash -ilc CMD` (VS Code reads the login environment that way),
# and not when fish itself started this bash
if [[ $- == *i* && -z ${BASH_EXECUTION_STRING:-} ]] && command -v fish &> /dev/null \
    && [[ $(ps -o comm= -p $PPID) != *fish* ]]; then
    exec fish
fi
