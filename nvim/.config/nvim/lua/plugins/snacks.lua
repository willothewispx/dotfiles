return {
  "folke/snacks.nvim",
  enabled = false,
  priority = 1000,
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    {
      "<leader>e",
      function()
        Snacks.explorer()
      end,
      desc = "Toggle explorer",
    },
  },
  ---@type snacks.Config
  opts = {
    picker = {
      enabled = true,
      sources = {
        explorer = {
          hidden = true,
          ignored = true,
        },
      },
    },
    explorer = {
      enabled = true,
      replace_netrw = true,
    },
  },
}
