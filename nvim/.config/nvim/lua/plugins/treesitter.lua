return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  lazy = false,
  config = function()
    local languages = {
      "bash",
      "css",
      "diff",
      "dockerfile",
      "go",
      "html",
      "http",
      "javascript",
      "json",
      "jsonc",
      "lua",
      "markdown",
      "markdown_inline",
      "python",
      "query",
      "regex",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "yaml",
    }

    local ts = require("nvim-treesitter")
    ts.setup()
    ts.install(languages)

    vim.api.nvim_create_autocmd("FileType", {
      pattern = languages,
      callback = function(args)
        pcall(vim.treesitter.start, args.buf)
        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
