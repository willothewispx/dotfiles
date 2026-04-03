return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "modern",
    spec = {
      { "<leader>", group = "leader" },
      { "<leader>a", group = "ai" },
      { "<leader>g", group = "git" },
      { "<leader>t", group = "todo" },
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
