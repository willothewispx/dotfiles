-- Mason: installer for LSP/DAP/formatters
require('mason').setup()
require('mason-lspconfig').setup({ ensure_installed = { 'lua_ls', 'gopls', 'ts_ls' } })

-- LSP config
local capabilities = vim.lsp.protocol.make_client_capabilities()

local servers = { 'lua_ls', 'gopls', 'ts_ls' }

-- Neovim 0.11+ native LSP config only
for _, name in ipairs(servers) do
  local cfg_factory = vim.lsp.config[name]
  if type(cfg_factory) == 'function' then
    vim.lsp.start(cfg_factory({ capabilities = capabilities }))
  end
end

-- Basic LSP keymaps
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'LSP: Go to definition' })
vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = 'LSP: References' })
vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'LSP: Hover' })
