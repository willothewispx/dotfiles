return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    {
      "<leader>e",
      function()
        require("neo-tree.command").execute({
          toggle = true,
          reveal = true,
          source = "filesystem",
          position = "left",
        })
      end,
      desc = "Toggle file tree",
    },
    {
      "<leader>E",
      function()
        require("neo-tree.command").execute({
          reveal = true,
          source = "filesystem",
          position = "left",
          focus = true,
        })
      end,
      desc = "Focus file tree",
    },
  },
  opts = {
    close_if_last_window = true,
    popup_border_style = "rounded",
    enable_git_status = true,
    enable_diagnostics = true,
    open_files_do_not_replace_types = {
      "terminal",
      "Trouble",
      "qf",
      "edgy",
      "text.kulala_ui",
      "json.kulala_ui",
      "http.kulala_ui",
    },
    filesystem = {
      hijack_netrw_behavior = "open_default",
      filtered_items = {
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = false,
      },
      follow_current_file = {
        enabled = true,
        leave_dirs_open = false,
      },
      use_libuv_file_watcher = true,
      window = {
        mappings = {
          ["."] = "set_root",
          ["H"] = "toggle_hidden",
        },
      },
    },
    window = {
      position = "left",
      width = 36,
    },
  },
}
