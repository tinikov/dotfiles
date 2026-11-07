-- Customize Mason
-- Nothing is installed up front. Opening a buffer of a filetype listed below installs
-- the Mason packages it needs (names as shown in `:Mason`); AstroNvim enables a language
-- server as soon as its package finishes installing, so the buffer picks it up in place.
-- Installed packages are updated from `:Mason` with `U`.

-- gopls and delve are built with `go install`, so only ask for them where Go exists
local function has_go() return vim.fn.executable "go" == 1 end
-- astrocommunity's Lua pack skips selene on aarch64 (no Mason build there)
local function has_selene_build() return vim.uv.os_uname().machine ~= "aarch64" end

local web = { "vtsls", "eslint-lsp", "prettierd", "js-debug-adapter" }
local gopls = { "gopls", condition = has_go }

local packages_by_ft = {
  css = { "css-lsp", "prettierd" },
  scss = { "css-lsp", "prettierd" },
  less = { "css-lsp", "prettierd" },
  html = { "html-lsp", "prettierd" },
  javascript = web,
  javascriptreact = web,
  typescript = web,
  typescriptreact = web,
  json = { "json-lsp", "prettierd" },
  jsonc = { "json-lsp", "prettierd" },
  lua = { "lua-language-server", "stylua", { "selene", condition = has_selene_build } },
  python = { "basedpyright", "ruff", "debugpy" },
  rust = { "rust-analyzer", "codelldb" },
  toml = { "taplo" },
  go = { gopls, { "delve", condition = has_go } },
  gomod = { gopls },
  gowork = { gopls },
}

local handled = {}
local function install_for_filetype(args)
  local ft = vim.bo[args.buf].filetype
  local wanted = packages_by_ft[ft]
  if not wanted or handled[ft] then return end
  handled[ft] = true

  local registry = require "mason-registry"
  registry.refresh(vim.schedule_wrap(function()
    for _, entry in ipairs(wanted) do
      local name, condition = entry, nil
      if type(entry) == "table" then name, condition = entry[1], entry.condition end
      if (not condition or condition()) and registry.has_package(name) then
        local pkg = registry.get_package(name)
        if not pkg:is_installed() and not pkg:is_installing() then
          require("astrocore").notify(("Mason: installing `%s`"):format(name))
          pkg:install(nil, function(success)
            if not success then
              require("astrocore").notify(("Mason: failed to install `%s`"):format(name), vim.log.levels.ERROR)
            end
          end)
        end
      end
    end
  end))
end

---@type LazySpec
return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = function(_, opts)
      -- AstroNvim routes every automatic install through this plugin, and community packs
      -- add to its list; empty it so neither startup nor `:MasonToolsUpdate` installs anything
      opts.ensure_installed = {}
      opts.run_on_start = false
    end,
  },
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      autocmds = {
        mason_install_on_demand = {
          {
            event = "FileType",
            desc = "Install the Mason packages a filetype needs the first time it is opened",
            callback = install_for_filetype,
          },
        },
      },
    },
  },
}
