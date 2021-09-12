-- Setup lspistall
require'lspinstall'.setup() -- important

-- Enable snippet support
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local servers = require'lspinstall'.installed_servers()

for _, server in pairs(servers) do
  require'lspconfig'[server].setup{
    on_attach = require('denes.lsp.options').custom_attach,
    capabilities = capabilities,
  }
end
