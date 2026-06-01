return {
  "mistweaverco/kulala.nvim",
  ft = { "http", "rest" },
  opts = {
    global_keymaps = false,
    kulala_keymaps_prefix = "",
    environment_scope = "g",
    default_env = "dev",
  },
  keys = {
    { "<leader>Rs", desc = "HTTP send request" },
    { "<leader>Ra", desc = "HTTP send all requests" },
    { "<leader>Rb", desc = "HTTP scratchpad" },
    { "<leader>Re", desc = "HTTP select environment" },
  },
  config = function(_, opts)
    local selected_env_file = vim.fn.stdpath("state") .. "/kulala/selected_env"
    local saved_env = vim.fn.filereadable(selected_env_file) == 1 and vim.fn.readfile(selected_env_file)[1] or nil

    if saved_env and saved_env ~= "" then
      opts.default_env = saved_env
      vim.g.kulala_selected_env = saved_env
    end

    require("kulala").setup(opts)

    vim.api.nvim_create_autocmd("VimLeavePre", {
      group = vim.api.nvim_create_augroup("kulala_selected_env", { clear = true }),
      callback = function()
        local env = vim.g.kulala_selected_env
        if type(env) ~= "string" or env == "" then
          return
        end

        vim.fn.mkdir(vim.fn.fnamemodify(selected_env_file, ":h"), "p")
        vim.fn.writefile({ env }, selected_env_file)
      end,
    })

    local group = vim.api.nvim_create_augroup("kulala_response_keys", { clear = true })
    vim.api.nvim_create_autocmd("BufWinEnter", {
      group = group,
      pattern = "kulala://ui",
      callback = function(ev)
        vim.keymap.set("n", "q", function()
          require("kulala.ui").close_kulala_buffer()
        end, {
          buffer = ev.buf,
          silent = true,
          desc = "Close Kulala response",
        })

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
