return {
  "mistweaverco/kulala.nvim",
  ft = { "http", "rest" },
  opts = {
    global_keymaps = false,
    kulala_keymaps_prefix = "",
    environment_scope = "g",
  },
  keys = {
    { "<leader>Rs", desc = "HTTP send request" },
    { "<leader>Ra", desc = "HTTP send all requests" },
    { "<leader>Rb", desc = "HTTP scratchpad" },
    { "<leader>Re", desc = "HTTP select environment" },
  },
  config = function(_, opts)
    require("kulala").setup(opts)

    local group = vim.api.nvim_create_augroup("kulala_response_keys", { clear = true })
    vim.api.nvim_create_autocmd("BufWinEnter", {
      group = group,
      pattern = "kulala://ui",
      callback = function(ev)
        vim.keymap.set("n", "<C-h>", "<C-w>p", {
          buffer = ev.buf,
          silent = true,
          desc = "Back to request window",
        })
      end,
    })

    vim.keymap.set("n", "<leader>Rs", function()
      require("kulala").run()
    end, { desc = "HTTP send request" })

    vim.keymap.set("n", "<leader>Ra", function()
      require("kulala").run_all()
    end, { desc = "HTTP send all requests" })

    vim.keymap.set("n", "<leader>Rb", function()
      require("kulala").scratchpad()
    end, { desc = "HTTP scratchpad" })

    vim.keymap.set("n", "<leader>Re", function()
      require("kulala").set_selected_env()
    end, { desc = "HTTP select environment" })
  end,
}
