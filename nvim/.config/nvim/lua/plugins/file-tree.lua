return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    {
      "<leader>e",
      function()
        require("nvim-tree.api").tree.toggle({
          find_file = true,
          focus = true,
          update_root = true,
        })
      end,
      desc = "Toggle file tree",
    },
    {
      "<leader>E",
      function()
        require("nvim-tree.api").tree.find_file({
          open = true,
          focus = true,
          update_root = true,
        })
      end,
      desc = "Focus file tree",
    },
  },
  opts = {
    sync_root_with_cwd = true,
    respect_buf_cwd = true,
    view = {
      width = {
        min = 40,
        max = 180,
        padding = 1,
      },
    },
    update_focused_file = {
      enable = true,
      update_root = true,
    },
  },
}
