local map = vim.keymap.set

-- Better defaults
map('n', '<Esc>', '<cmd>nohlsearch<CR>', { silent = true })


-- Window navigation
map('n', '<C-h>', '<C-w>h')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-l>', '<C-w>l')

-- mini.pick examples
map('n', '<leader>ff', function()
  require('mini.pick').builtin.files()
end)
map('n', '<leader>fg', function()
  require('mini.pick').builtin.grep_live()
end)
map('n', '<leader>fb', function()
  require('mini.pick').builtin.buffer()
end)


