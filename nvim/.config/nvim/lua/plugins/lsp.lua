local servers = {
  "lua_ls",
  "ts_ls",
  "pyright",
  "bashls",
  "html",
  "cssls",
  "jsonls",
}

local function on_attach(_, bufnr)
  local function map(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
  end

  map("n", "gd", vim.lsp.buf.definition, "LSP: Goto definition")
  map("n", "gD", vim.lsp.buf.declaration, "LSP: Goto declaration")
  map("n", "K", vim.lsp.buf.hover, "LSP: Hover")
  map("n", "gi", vim.lsp.buf.implementation, "LSP: Goto implementation")
  map("n", "gr", vim.lsp.buf.references, "LSP: References")
  map("n", "<leader>cr", vim.lsp.buf.rename, "LSP: Rename")
  map("n", "<leader>ca", vim.lsp.buf.code_action, "LSP: Code action")
  map("n", "<leader>cf", function()
    vim.lsp.buf.format({ async = true })
  end, "LSP: Format buffer")
end

return {
  "neovim/nvim-lspconfig",
  lazy = false,
  priority = 200,
  dependencies = { "hrsh7th/cmp-nvim-lsp" },
  keys = {
    {
      "<leader>cd",
      function()
        vim.diagnostic.open_float()
      end,
      desc = "Diagnostic float",
    },
    {
      "[d",
      function()
        vim.diagnostic.goto_prev({ float = true })
      end,
      desc = "Previous diagnostic",
    },
    {
      "]d",
      function()
        vim.diagnostic.goto_next({ float = true })
      end,
      desc = "Next diagnostic",
    },
  },
  config = function()
    local caps = require("cmp_nvim_lsp").default_capabilities()

    vim.lsp.config("*", {
      capabilities = caps,
      on_attach = on_attach,
    })

    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {
          runtime = { version = "LuaJIT" },
          workspace = {
            checkThirdParty = false,
            library = {
              vim.env.VIMRUNTIME,
              "${3rd}/luv/library",
            },
          },
        },
      },
    })

    vim.lsp.enable(servers)
  end,
}
