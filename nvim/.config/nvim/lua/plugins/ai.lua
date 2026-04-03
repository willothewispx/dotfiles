return {
  "nvim-lua/plenary.nvim",
  keys = {
    {
      "<leader>ai",
      function()
        require("config.codex_terminal").toggle()
      end,
      desc = "Codex terminal",
    },
    {
      "<leader>aI",
      function()
        require("config.codex_terminal").focus()
      end,
      desc = "Focus Codex terminal",
    },
    {
      "<leader>ab",
      function()
        require("config.codex_terminal").focus_code()
      end,
      desc = "Focus code window",
    },
    {
      "<leader>al",
      function()
        require("config.codex_terminal").run_here()
      end,
      desc = "Ask Codex about file",
    },
  },
}
