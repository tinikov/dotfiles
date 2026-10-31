# uv completions (uv's PATH comes from ~/.bash_profile)
if status is-interactive; and command -q uv
    uv generate-shell-completion fish | source
    uvx --generate-shell-completion fish | source
end
