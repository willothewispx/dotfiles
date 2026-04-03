return {
  "folke/todo-comments.nvim",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    {
      "]t",
      function()
        require("todo-comments").jump_next()
      end,
      desc = "Next todo comment",
    },
    {
      "[t",
      function()
        require("todo-comments").jump_prev()
      end,
      desc = "Previous todo comment",
    },
    { "<leader>tt", "<cmd>TodoTelescope<cr>", desc = "Todo comments" },
    { "<leader>tq", "<cmd>TodoQuickFix<cr>", desc = "Todo quickfix" },
  },
  opts = {
    signs = true,
    highlight = {
      comments_only = false,
      keyword = "wide",
      after = "fg",
    },
    search = {
      command = "rg",
      args = {
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--hidden",
        "--glob",
        "!.git/*",
      },
    },
  },
}
