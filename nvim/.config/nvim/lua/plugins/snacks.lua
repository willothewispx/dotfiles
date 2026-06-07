local function refresh_neotree_after_lazygit()
  vim.defer_fn(function()
    local ok, manager = pcall(require, "neo-tree.sources.manager")
    if not ok then
      return
    end

    pcall(manager.refresh, "filesystem")
    pcall(manager.refresh, "git_status")
  end, 150)
end

local function with_neotree_lazygit_refresh(opts)
  opts = opts or {}
  opts.win = opts.win or {}

  local on_close = opts.win.on_close
  opts.win.on_close = function(win)
    if on_close then
      pcall(on_close, win)
    end
    refresh_neotree_after_lazygit()
  end

  return opts
end

local function open_lazygit(opts)
  Snacks.lazygit.open(with_neotree_lazygit_refresh(opts))
end

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
    zen = {
      center = true,
      toggles = {
        dim = false,
      },
      win = {
        width = 110,
      },
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
          {
            icon = "󰊢 ",
            key = "n",
            desc = "Lazygit",
            action = function()
              open_lazygit()
            end,
          },
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
      "<leader>gg",
      function()
        open_lazygit()
      end,
      desc = "Lazygit",
    },
    {
      "<leader>gl",
      function()
        Snacks.lazygit.log(with_neotree_lazygit_refresh())
      end,
      desc = "Lazygit log",
    },
    {
      "<leader>gf",
      function()
        Snacks.lazygit.log_file(with_neotree_lazygit_refresh())
      end,
      desc = "Lazygit file log",
    },
    {
      "<leader>gb",
      function()
        open_lazygit({ args = { "branch" } })
      end,
      desc = "Lazygit branches",
    },
    {
      "<leader>gs",
      function()
        open_lazygit({ args = { "stash" } })
      end,
      desc = "Lazygit stash",
    },
    {
      "<leader>z",
      function()
        Snacks.zen()
      end,
      desc = "Toggle Zen Mode",
    },
    {
      "<leader>Z",
      function()
        Snacks.zen.zoom()
      end,
      desc = "Toggle Zoom",
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
