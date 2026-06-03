return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  ---@type snacks.Config
  opts = {
    picker = {
      sources = {
        files = {
          hidden = true,
          exclude = { ".git" },
        },
        grep = {
          hidden = true,
          exclude = { ".git" },
        },
      },
    },
    lazygit = {
      configure = true,
    },
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
  keys = {
    {
      "<leader>Gg",
      function()
        Snacks.lazygit()
      end,
      desc = "Lazygit",
    },
    {
      "<leader>Gl",
      function()
        Snacks.lazygit.log()
      end,
      desc = "Lazygit log",
    },
    {
      "<leader>Gf",
      function()
        Snacks.lazygit.log_file()
      end,
      desc = "Lazygit file log",
    },
    {
      "<leader>Gb",
      function()
        Snacks.lazygit.open({ args = { "branch" } })
      end,
      desc = "Lazygit branches",
    },
    {
      "<leader>Gs",
      function()
        Snacks.lazygit.open({ args = { "stash" } })
      end,
      desc = "Lazygit stash",
    },
    {
      "<leader>ff",
      function()
        Snacks.picker.files()
      end,
      desc = "Find files",
    },
    {
      "<leader>fF",
      function()
        Snacks.picker.files({ ignored = true })
      end,
      desc = "Find ignored files",
    },
    {
      "<leader>fg",
      function()
        Snacks.picker.grep()
      end,
      desc = "Grep in files",
    },
    {
      "<leader>fG",
      function()
        Snacks.picker.grep({ ignored = true })
      end,
      desc = "Grep ignored files",
    },
    {
      "<leader>fb",
      function()
        Snacks.picker.buffers()
      end,
      desc = "Find buffers",
    },
    {
      "<leader>fs",
      function()
        Snacks.picker.lines()
      end,
      desc = "Find in current file",
    },
    {
      "<leader>fh",
      function()
        Snacks.picker.help()
      end,
      desc = "Find help",
    },
    {
      "<leader>gl",
      function()
        Snacks.picker.git_log()
      end,
      desc = "Git log",
    },
    -- Extension/filetype one-off grep mappings are no longer needed.
    -- Useful picker syntax:
    --   `file:lua$ 'function` -> match exact `function` in lua files
    --   `!node_modules file:ts$ render` -> exclude node_modules, narrow to ts files
    --   `needle -- -e=lua` or `needle -- -g=*.ts` -> pass picker/rg args after `--`
    {
      "<leader>un",
      function()
        Snacks.notifier.show_history()
      end,
      desc = "Notification history",
    },
    {
      "<leader>uN",
      function()
        Snacks.notifier.hide()
      end,
      desc = "Dismiss notifications",
    },
  },
}
