-- Customize the dashboard header

---@type LazySpec
return {
  "folke/snacks.nvim",
  opts = {
    dashboard = {
      preset = {
        header = table.concat({
          " _|_ o ._  o |\\ |    o ._ _ ",
          "  |_ | | | | | \\| \\/ | | | |",
          "",
          "- 137.019 -",
        }, "\n"),
      },
    },
  },
}
