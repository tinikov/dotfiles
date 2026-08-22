-- Customize Mason plugins

---@type LazySpec
return {
  -- language servers
  {
    "mason-org/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
        "basedpyright",
        "cssls",
        "eslint",
        "gopls",
        "html",
        "jsonls",
        "ruff",
        "rust_analyzer",
        "taplo",
        "vtsls",
      })
    end,
  },
  -- formatters and linters exposed through none-ls
  {
    "jay-babu/mason-null-ls.nvim",
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "prettierd" })
    end,
  },
  -- debug adapters
  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
        "codelldb",
        "delve",
        "js",
        "python",
      })
    end,
  },
}
