return {
  "folke/sidekick.nvim",
  dependencies = {
    "folke/snacks.nvim",
  },
  opts = {
    nes = {
      enabled = false,
    },
    cli = {
      watch = true,
      mux = {
        enabled = true,
        backend = "tmux",
        create = "terminal",
      },
      win = {
        layout = "right",
        split = {
          width = 0.42,
        },
      },
    },
  },
  keys = {
    {
      "<leader>ai",
      function()
        require("sidekick.cli").toggle({ name = "codex", focus = true })
      end,
      desc = "Codex terminal",
    },
    {
      "<leader>aI",
      function()
        require("sidekick.cli").focus({ name = "codex" })
      end,
      desc = "Focus Codex terminal",
    },
    {
      "<leader>ab",
      function()
        vim.cmd("wincmd p")
      end,
      desc = "Focus previous window",
    },
    {
      "<leader>al",
      function()
        require("sidekick.cli").send({ name = "codex", msg = "{file}" })
      end,
      desc = "Ask Codex about file",
    },
    {
      "<leader>as",
      function()
        require("sidekick.cli").select({ filter = { installed = true }, focus = true })
      end,
      desc = "Select AI CLI",
    },
  },
}
