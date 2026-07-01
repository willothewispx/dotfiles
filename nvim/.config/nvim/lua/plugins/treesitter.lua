return {
  "romus204/tree-sitter-manager.nvim",
  lazy = false,
  opts = {
    auto_install = true,
    -- don't install these as they come with neovim by default
    noauto_install = {
      "c",
      "lua",
      "markdown",
      "markdown_inline",
      "query",
      "vim",
      "vimdoc",
    },
  },
}
