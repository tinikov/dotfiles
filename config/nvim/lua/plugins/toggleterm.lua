-- Open interactive terminals (<Leader>tf/th/tv, <F7>, neo-tree T*) in fish.
-- Only toggleterm's own `shell` is changed; `vim.o.shell` stays bash so `:!`,
-- formatters and other plugins keep running POSIX commands.
-- Terminals launched with an explicit cmd (lazygit, node, python...) are unaffected.

---@type LazySpec
return {
  "akinsho/toggleterm.nvim",
  opts = {
    shell = function() return vim.fn.executable "fish" == 1 and "fish" or vim.o.shell end,
  },
}
