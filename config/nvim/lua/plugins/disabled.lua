-- Default AstroNvim plugins that are switched off; `:Lazy clean` removes them from disk

---@type LazySpec
return {
  { "max397574/better-escape.nvim", enabled = false }, -- `jk`/`jj` as Esc in insert mode
}
