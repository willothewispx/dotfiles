local null_ls = require("null-ls")

local sources = {

    -- Python
    null_ls.builtins.formatting.autopep8,
    null_ls.builtins.diagnostics.flake8,

    -- HTML, Javascript
    null_ls.builtins.formatting.prettier,
    null_ls.builtins.diagnostics.eslint_d,

    -- Ansible
    null_ls.builtins.diagnostics.ansiblelint.with({
        filetypes = {"yaml", "yml"}
    }),

    -- YAML
    null_ls.builtins.diagnostics.yamllint,
}

null_ls.setup({ sources = sources })
