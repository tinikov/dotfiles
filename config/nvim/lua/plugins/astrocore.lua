-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    features = {
      large_buf = { size = 1024 * 500, lines = 10000 },
    },
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    options = {
      opt = {
        colorcolumn = "120",
        number = true,
        relativenumber = true,
        signcolumn = "auto",
        spell = false,
        wrap = true,
      },
    },
    mappings = {
      n = {
        L = {
          function() require("astrocore.buffer").nav(vim.v.count > 0 and vim.v.count or 1) end,
          desc = "Next buffer",
        },
        H = {
          function() require("astrocore.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1)) end,
          desc = "Previous buffer",
        },
        ["<Leader>b"] = { desc = "Buffers" },
        ["<Leader>bD"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Pick to close",
        },
      },
      v = {
        -- keep the selection after indenting
        ["<"] = "<gv",
        [">"] = ">gv",
        -- move the selected lines up and down
        J = ":move '>+1<cr><cr>gv",
        K = ":move '<-2<cr><cr>gv",
      },
      t = {
        ["<esc>"] = "<C-\\><C-n>",
      },
    },
  },
}
