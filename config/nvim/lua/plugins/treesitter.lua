-- Customize Treesitter
-- nvim-treesitter only downloads parsers now; everything else lives in AstroCore.
-- AstroNvim already enables highlight/indent, installs missing parsers on demand
-- (`auto_install = true`) and preinstalls bash, c, lua, markdown, markdown_inline,
-- python, query, vim and vimdoc, so this list only preinstalls the rest of the
-- stack on a fresh machine. `treesitter.ensure_installed` is an `opts_extend`
-- key, so a plain table extends the default list instead of replacing it.

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    treesitter = {
      ensure_installed = {
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
        "rust",
        "scss",
        "toml",
        "tsx",
        "typescript",
        "yaml",
      },
    },
  },
}
