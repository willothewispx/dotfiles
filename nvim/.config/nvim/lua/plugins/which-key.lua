return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "modern",
    spec = {
      { "<leader>", group = "leader" },
      { "<leader>a", group = "ai" },
      { "<leader>b", group = "buffers" },
      { "<leader>f", group = "find" },
      { "<leader>g", group = "git" },
      { "<leader>l", group = "lines / lsp" },
      { "<leader>R", group = "rest" },
      { "<leader>t", group = "terminal / todo" },
      { "<leader>u", group = "ui" },
      { "<leader>x", group = "trouble" },
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
