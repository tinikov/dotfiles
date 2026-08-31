# uv: PATH + completions
if [ -e "$HOME/.local/bin/uv" ]
  source "$HOME/.local/bin/env.fish"
  uv generate-shell-completion fish | source
  uvx --generate-shell-completion fish | source
end
