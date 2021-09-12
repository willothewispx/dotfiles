local M = {}

function M.custom_attach(client)

  local buf_set_keymap = function(mode, key, result)
    vim.api.nvim_buf_set_keymap(0, mode, key, "<cmd>lua " .. result .. "<CR>", {noremap = true, silent = true})
  end
  -- vim.api.nvim_buf_set_option(0, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  buf_set_keymap('n', 'gD', 'vim.lsp.buf.declaration()')
  buf_set_keymap('n', 'gd', 'vim.lsp.buf.definition()')
  buf_set_keymap('n', 'K', 'vim.lsp.buf.hover()')
  buf_set_keymap('n', 'gi', 'vim.lsp.buf.implementation()')
  buf_set_keymap('n', '<leader>k', 'vim.lsp.buf.signature_help()')
  buf_set_keymap('n', 'gtd', 'vim.lsp.buf.type_definition()')
  buf_set_keymap('n', 'gr', 'vim.lsp.buf.references()')
  buf_set_keymap('n', '<leader>q', 'vim.lsp.diagnostic.set_loclist()')

  -- Set by lspsaga
  -- buf_set_keymap('n', 'ga', 'vim.lsp.buf.code_action()')
  -- buf_set_keymap('n', '<leader>rn', 'vim.lsp.buf.rename()')
  -- buf_set_keymap('n', 'ge', 'vim.lsp.diagnostic.show_line_diagnostics()')
  -- buf_set_keymap('n', '[e', 'vim.lsp.diagnostic.goto_prev()')
  -- buf_set_keymap('n', ']e', 'vim.lsp.diagnostic.goto_next()<CR>')

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap('n', '<leader>f', 'vim.lsp.buf.formatting()')
  elseif client.resolved_capabilities.document_range_formatting then
    buf_set_keymap('n', '<leader>f', 'vim.lsp.buf.range_formatting()')
  end

  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
  end
end

-- Autoformat go on save
vim.api.nvim_command[[autocmd BufWritePre *.go lua vim.lsp.buf.formatting_sync()]]

return M
