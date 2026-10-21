-- which-key 默认（classic 预设）不画边框，靠浮窗底色区分；透明背景下补上圆角线框

---@type LazySpec
return {
  "folke/which-key.nvim",
  opts = {
    win = { border = "rounded" },
  },
}
