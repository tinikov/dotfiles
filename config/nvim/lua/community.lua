-- AstroCommunity: import any community modules here.
-- Imported before the `plugins/` folder so user specs can override these.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.motion.nvim-surround" },
}
