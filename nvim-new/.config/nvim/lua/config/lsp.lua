-- Mason: installer for LSP/DAP/formatters
require('mason').setup()
require('mason-lspconfig').setup({ ensure_installed = { 'lua_ls', 'gopls', 'ts_ls' } })

-- LSP config
local capabilities = vim.lsp.protocol.make_client_capabilities()

local servers = { 'lua_ls', 'gopls', 'ts_ls' }

-- Neovim 0.11+ native LSP config using vim.lsp.config()
-- Configure lua_ls with enhanced settings
vim.lsp.config['lua_ls'] = {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = { '.luarc.json', '.luarc.jsonc', '.git' },
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      diagnostics = { 
        globals = { 'vim' },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file('', true),
        checkThirdParty = false
      },
      telemetry = { enable = false }
    }
  }
}

-- Configure other servers
vim.lsp.config['gopls'] = {
  cmd = { 'gopls' },
  filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
  root_markers = { 'go.mod', 'go.work', '.git' }
}

vim.lsp.config['ts_ls'] = {
  cmd = { 'typescript-language-server', '--stdio' },
  filetypes = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' },
  root_markers = { 'package.json', 'tsconfig.json', '.git' }
}

-- Enable all configured servers
for _, name in ipairs(servers) do
  vim.lsp.enable(name)
end

-- Basic LSP keymaps
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'LSP: Go to definition' })
vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = 'LSP: References' })
vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'LSP: Hover' })

-- Diagnostic navigation and display (using built-in vim.diagnostic)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Next diagnostic' })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Prev diagnostic' })
vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { desc = 'Show diagnostics' })
vim.keymap.set('n', '<leader>D', function() vim.diagnostic.open_float(nil, { severity = vim.diagnostic.severity.ERROR }) end, { desc = 'Show errors only' })
