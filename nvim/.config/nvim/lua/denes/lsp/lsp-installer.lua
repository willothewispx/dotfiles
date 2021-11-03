local lsp_installer = require("nvim-lsp-installer")

lsp_installer.on_server_ready(function(server)
  local opts = {}

  -- Use custom keybindings and options
  opts.on_attach = require("denes.lsp.options").custom_attach

  -- Lua Settings
  if server.name == "sumneko_lua" then
    opts.settings = {
      Lua = {
        diagnostics = {
          -- Get the language server to recognize the 'vim', 'use' global
          globals = {'vim', 'use'},
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file("", true),
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false,
        },
      },
    }
  end

  -- This setup() function is exactly the same as lspconfig's setup function (:help lspconfig-quickstart)
  server:setup(opts)
  vim.cmd [[ do User LspAttachBuffers ]]
end)

lsp_installer.settings {
    ui = {
        icons = {
            server_installed = "✓",
            server_pending = "➜",
            server_uninstalled = "✗"
        }
    }
}

-- Install servers
local function install_server(server)
  local lsp_installer_servers = require'nvim-lsp-installer.servers'
  local ok, server_analyzer = lsp_installer_servers.get_server(server)
  if ok then
    if not server_analyzer:is_installed() then
      -- server_analyzer:install(server)   -- will install in background
      lsp_installer.install(server)     -- install window will popup
    end
  end
end

local servers = {
  "tsserver",           -- for Typescript/Javascript
  "texlab",             -- for LaTeX
  "dockerls",           -- for Dockerfiles
  "gopls",              -- for Go
  "sumneko_lua",        -- for Lua
  "pyright",            -- for Python
  "bashls",             -- for Bash
}

-- install the LS
for _, server in ipairs(servers) do
  install_server(server)
end
