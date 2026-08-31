# dotfiles

Personal dotfiles for macOS (Apple Silicon). Fish is the main shell; configs are managed via symlinks.

## Setup

```shell
git clone <this-repo> ~/dotfiles
cd ~/dotfiles && ./init.sh
```

Then restart the terminal.

`init.sh` symlinks the configs (zsh, git, fish, starship, ghostty, nvim) into place — anything already there is backed up to `~/.dotfiles_backup` — and interactively offers to install Homebrew, a minimal `brew bundle` (Brewfile-minimal), uv, and rustup.

Machine-specific git identity (name/email) is prompted for on first run and stored in `~/.gitconfig.local`, outside this repo.
