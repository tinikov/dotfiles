---@type LazySpec
return {
  "EdenEast/nightfox.nvim",
  lazy = true,
  opts = {
    options = { transparent = true },
    -- 去掉状态栏、标签栏和浮窗的底色；窗口分隔线与浮窗边框同色
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
