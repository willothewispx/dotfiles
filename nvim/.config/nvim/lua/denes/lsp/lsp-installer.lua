require("mason-lspconfig").setup({
    ensure_installed = {
        "bashls", -- for Bash
        "cssls", -- for CSS
        "dockerls", -- for Dockerfiles
        "emmet_ls", -- for Emmet
        "eslint", -- for eslint
        "gopls", -- for Go
        "html", -- for HTML
        "intelephense", -- for PHP
        "jsonls", -- for JSON
        "pyright", -- for Python
        "sumneko_lua", -- for Lua
        "texlab", -- for LaTeX
        "tsserver", -- for Typescript/Javascript
        "yamlls", -- for YAML
    },
})

