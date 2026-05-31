return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
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
    vim.treesitter.language.register("json", "jsonc")

    vim.api.nvim_create_autocmd("FileType", {
      pattern = vim.list_extend(vim.deepcopy(languages), { "jsonc" }),
      callback = function(args)
        pcall(vim.treesitter.start, args.buf)
        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
