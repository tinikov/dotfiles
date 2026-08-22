-- AstroLSP allows you to customize the features in AstroNvim's LSP configuration engine
-- Configuration documentation can be found with `:h astrolsp`

---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    formatting = {
      format_on_save = { enabled = false },
      -- formatting is handled by ruff (Python), gopls (Go), rust_analyzer (Rust),
      -- stylua (Lua) and prettierd (web), so the servers below stay out of the way
      disabled = { "basedpyright", "cssls", "html", "jsonls", "lua_ls", "vtsls" },
      timeout_ms = 1000,
    },
    ---@diagnostic disable: missing-fields
    config = {
      basedpyright = {
        settings = {
          basedpyright = {
            disableOrganizeImports = true, -- ruff organizes imports
            analysis = { typeCheckingMode = "standard" },
          },
        },
      },
      gopls = {
        settings = {
          gopls = {
            gofumpt = true,
            staticcheck = true,
            usePlaceholders = true,
          },
        },
      },
      rust_analyzer = {
        settings = {
          ["rust-analyzer"] = {
            check = { command = "clippy" },
          },
        },
      },
    },
    mappings = {
      n = {
        gl = { function() vim.diagnostic.open_float() end, desc = "Hover diagnostics" },
      },
    },
    on_attach = function(client)
      -- ruff's hover is far thinner than basedpyright's, so let the type checker win
      if client.name == "ruff" then client.server_capabilities.hoverProvider = false end
    end,
  },
}
