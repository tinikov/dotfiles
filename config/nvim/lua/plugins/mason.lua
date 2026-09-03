-- Customize Mason
-- AstroNvim v6 manages every automatic install through mason-tool-installer and
-- discards the `ensure_installed` lists of mason-lspconfig, mason-null-ls and
-- mason-nvim-dap when it is present, so packages must be listed here under their
-- Mason package names (the names shown in `:Mason`).

-- gopls and delve are built with `go install`, so only ask for them where Go exists
local function has_go() return vim.fn.executable "go" == 1 end

---@type LazySpec
return {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  opts = function(_, opts)
    opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
      -- language servers
      "basedpyright",
      "css-lsp",
      "eslint-lsp",
      { "gopls", condition = has_go },
      "html-lsp",
      "json-lsp",
      "ruff",
      "rust-analyzer",
      "taplo",
      "vtsls",
      -- formatters and linters exposed through none-ls
      "prettierd",
      -- debug adapters
      "codelldb",
      "debugpy",
      { "delve", condition = has_go },
      "js-debug-adapter",
    })
  end,
}
