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
  require('mini.pick').builtin.buffers()
end)

-- File tree (neo-tree - sidebar)
map('n', '<leader>n', '<cmd>Neotree toggle<cr>', { desc = 'Toggle Neo-tree sidebar' })
map('n', '<leader>nf', '<cmd>Neotree reveal<cr>', { desc = 'Reveal current file in Neo-tree' })

-- Diff overlay (show detailed changes)
map('n', '<leader>do', function()
  require('mini.diff').toggle_overlay(0)
end, { desc = 'Toggle diff overlay' })

-- Code minimap
map('n', '<leader>m', function()
  require('mini.map').toggle()
end, { desc = 'Toggle minimap' })

-- Terminal (also <C-\> in any mode)
map('n', '<leader>t', '<cmd>ToggleTerm<cr>', { desc = 'Toggle terminal' })
