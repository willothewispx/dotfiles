local null_ls = require("null-ls")

local sources = {
    null_ls.builtins.formatting.autopep8,
    null_ls.builtins.formatting.stylua
}

null_ls.config({sources = sources})

require("lspconfig")["null-ls"].setup({
    -- see the nvim-lspconfig documentation for available configuration options
    on_attach = require("denes.lsp.options").custom_attach
})