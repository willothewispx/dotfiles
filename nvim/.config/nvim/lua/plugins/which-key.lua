return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "modern",
    spec = {
      { "<leader>", group = "leader" },
      { "<leader>b", group = "buffers" },
      { "<leader>c", group = "code / quickfix" },
      { "<leader>d", group = "debug" },
      { "<leader>f", group = "find" },
      { "<leader>g", group = "git" },
      { "<leader>l", group = "lines / lsp" },
      { "<leader>L", group = "LaTeX" },
      { "<leader>R", group = "rest" },
      { "<leader>t", group = "terminal" },
      { "<leader>u", group = "ui" },
      { "<leader>x", group = "trouble" },
      { "<leader>y", group = "yank" },
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = true })
      end,
      desc = "All keymaps (which-key)",
    },
  },
}
