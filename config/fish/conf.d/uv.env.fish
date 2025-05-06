
# PATH add .local
set UV_BIN "$HOME/.local/bin/uv"
if [ -e "$UV_BIN" ]
  source "$HOME/.local/bin/env.fish"
  uv generate-shell-completion fish | source
  uvx --generate-shell-completion fish | source
end
