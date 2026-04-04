return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  ---@type snacks.Config
  opts = {
    input = {
      enabled = true,
    },
    notifier = {
      enabled = true,
      timeout = 3000,
      style = "compact",
    },
    scroll = {
      enabled = true,
    },
    scope = {
      enabled = true,
    },
    statuscolumn = {
      enabled = true,
      left = { "mark", "sign" },
      right = { "fold", "git" },
      folds = {
        open = false,
        git_hl = false,
      },
      git = {
        patterns = { "GitSign", "MiniDiffSign" },
      },
    },
    dashboard = {
      enabled = true,
      width = 72,
      pane_gap = 4,
      preset = {
        header = table.concat({
          "███╗   ██╗██╗   ██╗██╗███╗   ███╗",
          "████╗  ██║██║   ██║██║████╗ ████║",
          "██╔██╗ ██║██║   ██║██║██╔████╔██║",
          "██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║",
          "██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║",
          "╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝",
        }, "\n"),
        keys = {
          { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = " ", key = "e", desc = "Explorer", action = ":Neotree toggle reveal left" },
          { icon = "󰊢 ", key = "n", desc = "Neogit", action = ":lua require('neogit').open()" },
          { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', { cwd = vim.fn.stdpath('config') })" },
          { icon = " ", key = "d", desc = "Diff View", action = ":DiffviewOpen" },
          { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
      },
      sections = {
        { section = "header" },
        { icon = " ", title = "Quick Actions", section = "keys", gap = 1, padding = 1, indent = 2 },
        { section = "startup", padding = 1 },
        {
          pane = 2,
          icon = " ",
          title = "Recent Projects",
          section = "projects",
          limit = 8,
          indent = 2,
          padding = 1,
          dirs = {
            vim.fn.expand("~/code/mochi-time"),
            vim.fn.expand("~/dotfiles"),
            vim.fn.expand("~/code/ansible-mac"),
          },
        },
        {
          pane = 2,
          icon = " ",
          title = "Recent Files",
          section = "recent_files",
          limit = 8,
          indent = 2,
          padding = 1,
        },
      },
    },
  },
}
