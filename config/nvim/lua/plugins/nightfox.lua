---@type LazySpec
return {
  "EdenEast/nightfox.nvim",
  lazy = true,
  opts = {
    options = { transparent = true },
    -- no background on the status line, tab line and floats; window separators match float borders
    groups = {
      all = {
        StatusLine = { bg = "NONE" },
        StatusLineNC = { bg = "NONE" },
        TabLine = { bg = "NONE" },
        TabLineFill = { bg = "NONE" },
        NormalFloat = { bg = "NONE" },
        WinSeparator = { link = "FloatBorder" },
      },
    },
  },
}
