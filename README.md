# dotfiles

Personal dotfiles for macOS (Apple Silicon) and Linux, including servers without root. The login shell is bash everywhere: `bash_profile` sets up the environment (PATH, EDITOR, LANG) and then hands interactive sessions to fish. Configs are managed via symlinks; colors follow Ghostty's Dayfox light theme.

## Setup

```shell
git clone <this-repo> ~/dotfiles
cd ~/dotfiles && ./init.sh
```

Then restart the terminal.

`init.sh` symlinks the configs into place — anything already there, including a link pointing elsewhere, is moved to `~/.dotfiles_backup` — and asks before every install:

- **Both:** bash_profile, git, fish, starship, tmux, vim. Optional uv (plus its fish completions) and rustup.
- **macOS:** also ghostty and nvim; offers Homebrew, `Brewfile` (base apps), `Brewfile.extra` (optional apps), and brew's bash as the login shell (macOS defaults to zsh).
- **Linux:** installs missing `git fish tmux rg fd bat` with the package manager (sudo), or, without root, downloads static builds of fish/rg/fd/bat into `~/.local/bin`. Offers a static starship there too (skip it when `$HOME` is on a network filesystem; fish's own prompt is used then). Asks before linking the nvim config. Warns if terminfo for `xterm-ghostty` is missing; fix it from the Mac with `infocmp -x xterm-ghostty | ssh <host> -- tic -x -`.

The git identity is asked for after the installs, so a fresh Linux box has git by then.

## Machine-local files

These stay outside the repo; templates with macOS and Linux sections are in `examples/`:

| File | Purpose |
|---|---|
| `~/.bashrc` | Sourced by `bash_profile` before switching to fish: `/etc/bashrc`, HPC module loads |
| `~/.config/fish.local.fish` | Sourced last by `config.fish`: machine aliases and functions |
| `~/.gitconfig.local` | Git identity, included by `gitconfig` |

fish keeps its own state (`fish_variables`, `conf.d/fish_frozen_*.fish`) in the linked config dir; it is gitignored.

## Setup with Claude Code

`.claude/skills/dotfiles-setup/` describes how to inspect a machine, pick an install method, and fix the known terminal issues (tmux true color, `ls` colors, terminfo, old vim). On a machine that can run Claude Code:

```shell
git clone <this-repo> ~/dotfiles
cd ~/dotfiles && claude
```

Then ask it to set up the machine; it asks before installing anything.
