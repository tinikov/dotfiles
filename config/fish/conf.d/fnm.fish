# fnm
set FNM_PATH "/opt/homebrew/Cellar/fnm"
if [ -d "$FNM_PATH" ]
  fnm env --use-on-cd --shell fish | source
end
