local config_group = vim.api.nvim_create_augroup("UserConfig", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  group = config_group,
  callback = function()
    vim.highlight.on_yank({ timeout = 200 })
  end,
})
