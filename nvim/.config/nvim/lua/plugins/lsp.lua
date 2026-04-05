local servers = {
  "bashls",
  "cssls",
  "dockerls",
  "html",
  "gopls",
  "jsonls",
  "kulala_ls",
  "lua_ls",
  "pyright",
  "ts_ls",
}

local function format_buffer(bufnr)
  local ft = vim.bo[bufnr].filetype
  if (ft == "http" or ft == "rest") and vim.fn.executable("kulala-fmt") == 1 then
    local file = vim.api.nvim_buf_get_name(bufnr)
    if file == "" then
      vim.notify("Save the HTTP file before formatting with kulala-fmt.", vim.log.levels.WARN)
      return
    end

    vim.cmd.write()
    local result = vim.system({ "kulala-fmt", "format", file }, { text = true }):wait()
    if result.code ~= 0 then
      vim.notify(result.stderr ~= "" and result.stderr or "kulala-fmt failed", vim.log.levels.ERROR)
      return
    end

    vim.cmd.edit()
    return
  end

  vim.lsp.buf.format({ async = true, bufnr = bufnr })
end

local function on_attach(_, bufnr)
  local function map(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
  end

  map("n", "gd", vim.lsp.buf.definition, "LSP: Goto definition")
  map("n", "gD", vim.lsp.buf.declaration, "LSP: Goto declaration")
  map("n", "K", vim.lsp.buf.hover, "LSP: Hover")
  map("n", "gi", vim.lsp.buf.implementation, "LSP: Goto implementation")
  map("n", "gr", function()
    vim.cmd("Trouble lsp_references toggle focus=false win.position=bottom")
  end, "LSP: References (Trouble)")
  map("n", "gR", function()
    require("trouble").focus("lsp_references")
  end, "LSP: Focus references (Trouble)")
  map("n", "<leader>cr", vim.lsp.buf.rename, "LSP: Rename")
  map("n", "<leader>ca", vim.lsp.buf.code_action, "LSP: Code action")
  map("n", "<leader>ll", function()
    format_buffer(bufnr)
  end, "LSP: Format buffer")
end

local lua_workspace_library = {
  vim.env.VIMRUNTIME,
  "${3rd}/luv/library",
}

local snacks_library = vim.fn.stdpath("data") .. "/lazy/snacks.nvim"
if vim.uv.fs_stat(snacks_library) then
  table.insert(lua_workspace_library, snacks_library)
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
        vim.diagnostic.jump({ count = -1, float = true })
      end,
      desc = "Previous diagnostic",
    },
    {
      "]d",
      function()
        vim.diagnostic.jump({ count = 1, float = true })
      end,
      desc = "Next diagnostic",
    },
  },
  config = function()
    local caps = require("cmp_nvim_lsp").default_capabilities()

    vim.diagnostic.config({
      virtual_text = false,
      virtual_lines = {
        current_line = true,
      },
      float = {
        border = "rounded",
      },
      severity_sort = true,
      signs = true,
      underline = true,
    })

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
            library = lua_workspace_library,
          },
        },
      },
    })

    vim.lsp.enable(servers)
  end,
}
