-- Customize neo-tree

---@type LazySpec
return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    sources = { "filesystem" },
    source_selector = { winbar = false },
    filesystem = {
      filtered_items = {
        hide_gitignored = false,
        always_show = { ".gitignore" },
        never_show = { ".git", ".DS_Store" },
      },
    },
  },
}
