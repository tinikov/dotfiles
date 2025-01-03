-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- Customize None-ls sources

---@type LazySpec
return {
  "nvimtools/none-ls.nvim",
  opts = function(_, config)
    -- config variable is the default configuration table for the setup function call
    local null_ls = require "null-ls"

    -- Check supported formatters and linters
    -- https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/formatting
    -- https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
    config.sources = {
      -- Set a formatter
      null_ls.builtins.formatting.black,
      null_ls.builtins.formatting.clang_format.with {
        disabled_filetypes = { "c", "cpp", "cuda", "proto" },
      },
      null_ls.builtins.formatting.djlint.with {
        filetypes = { "html", "htmldjango" },
      },
      null_ls.builtins.formatting.shfmt,
      null_ls.builtins.formatting.stylua,
    }
    return config -- return final config table
  end,
}
