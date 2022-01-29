local lsp_installer = require("nvim-lsp-installer")
local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true

lsp_installer.on_server_ready(function(server)
    local opts = {}

    -- Use custom keybindings and options
    opts.on_attach = require("denes.lsp.options").custom_attach

    -- Tell neovim that snippets are supported
    opts.capabilities = capabilities

    -- Lua Settings
    if server.name == "sumneko_lua" then
        opts.settings = {
            Lua = {
                diagnostics = {
                    -- Get the language server to recognize the 'vim', 'use' global
                    globals = { "vim", "use" },
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

    if server.name == "eslint" then
        opts.on_attach = function(client, bufnr)
            -- neovim's LSP client does not currently support dynamic capabilities registration, so we need to set
            -- the resolved capabilities of the eslint server ourselves!
            client.resolved_capabilities.document_formatting = true
        end
        opts.settings = {
            format = { enable = true }, -- this will enable formatting
        }
    end

    -- HTML/EMMET
    if server.name == "emmet_ls" then
        opts.filetypes = { "html", "twig", "css" }
    end

    -- tsserver
    if server.name == "tsserver" then
        -- do not use tsserver for formatting
        -- we use null-ls instead
        opts.on_attach = function(client)
            client.resolved_capabilities.document_formatting = false
            client.resolved_capabilities.document_range_formatting = false
        end
    end

    -- jsonls
    if server.name == "jsonls" then
        -- do not use tsserver for formatting
        -- we use null-ls instead
        opts.on_attach = function(client)
            client.resolved_capabilities.document_formatting = false
            client.resolved_capabilities.document_range_formatting = false
        end
    end

    -- This setup() function is exactly the same as lspconfig's setup function (:help lspconfig-quickstart)
    server:setup(opts)
    vim.cmd([[ do User LspAttachBuffers ]])
end)

lsp_installer.settings({
    ui = {
        icons = {
            server_installed = "✓",
            server_pending = "➜",
            server_uninstalled = "✗",
        },
    },
})

-- Install servers
local function install_server(server)
    local lsp_installer_servers = require("nvim-lsp-installer.servers")
    local ok, server_analyzer = lsp_installer_servers.get_server(server)
    if ok then
        if not server_analyzer:is_installed() then
            -- server_analyzer:install(server)   -- will install in background
            lsp_installer.install(server) -- install window will popup
        end
    end
end

local servers = {
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
    "tailwindcss", -- for tailwind
    "texlab", -- for LaTeX
    "tsserver", -- for Typescript/Javascript
    "yamlls", -- for YAML
}

-- install the LS
for _, server in ipairs(servers) do
    install_server(server)
end
