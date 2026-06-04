return {
  "folke/trouble.nvim",
  cmd = "Trouble",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  specs = {
    {
      "folke/snacks.nvim",
      opts = function(_, opts)
        opts = opts or {}
        opts.picker = opts.picker or {}
        opts.picker.actions = require("trouble.sources.snacks").actions
        opts.picker.win = opts.picker.win or {}
        opts.picker.win.input = opts.picker.win.input or {}
        opts.picker.win.input.keys = vim.tbl_deep_extend("force", opts.picker.win.input.keys or {}, {
          ["<c-t>"] = {
            "trouble_open",
            mode = { "n", "i" },
          },
        })
      end,
    },
  },
  keys = {
    { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
    { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer diagnostics (Trouble)" },
    { "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols (Trouble)" },
    { "<leader>xl", "<cmd>Trouble lsp toggle focus=false win.position=bottom<cr>", desc = "LSP list (Trouble)" },
    { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location list (Trouble)" },
    { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix list (Trouble)" },
    { "<leader>xR", "<cmd>Trouble lsp_references focus<cr>", desc = "Focus references (Trouble)" },
  },
  opts = {
    focus = false,
    auto_preview = true,
    auto_refresh = true,
  },
}
