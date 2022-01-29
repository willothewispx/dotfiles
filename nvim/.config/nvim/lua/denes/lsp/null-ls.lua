local null_ls = require("null-ls")

local sources = {

    -- Python
    null_ls.builtins.formatting.autopep8,
    null_ls.builtins.diagnostics.flake8,

    -- HTML, Javascript
    null_ls.builtins.formatting.prettier,

    -- Twig
    null_ls.builtins.formatting.djhtml.with({
        filetypes = { "django", "jinja.html", "htmldjango", "twig" },
    }),

    -- Lua
    null_ls.builtins.formatting.stylua.with({
        extra_args = { "--indent-type", "Spaces" },
    }),
}

null_ls.setup({
    sources = sources,
    on_attach = require("denes.lsp.options").custom_attach,
})
