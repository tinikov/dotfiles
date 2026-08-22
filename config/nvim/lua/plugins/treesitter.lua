-- Customize Treesitter
-- nvim-treesitter only downloads parsers now; everything else lives in AstroCore

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = function(_, opts)
    local astrocore = require "astrocore"
    opts.treesitter = astrocore.extend_tbl(opts.treesitter, { highlight = true, indent = true })
    opts.treesitter.ensure_installed = astrocore.list_insert_unique(opts.treesitter.ensure_installed, {
      "css",
      "go",
      "gomod",
      "gosum",
      "gowork",
      "html",
      "javascript",
      "jsdoc",
      "json",
      "jsonc",
      "markdown",
      "markdown_inline",
      "python",
      "rust",
      "scss",
      "toml",
      "tsx",
      "typescript",
      "yaml",
    })
  end,
}
