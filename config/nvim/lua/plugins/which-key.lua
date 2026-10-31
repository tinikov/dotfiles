-- which-key's classic preset draws no border and relies on the float background,
-- which the transparent theme removes; add a rounded border instead

---@type LazySpec
return {
  "folke/which-key.nvim",
  opts = {
    win = { border = "rounded" },
  },
}
