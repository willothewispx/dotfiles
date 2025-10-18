-- mini.nvim modules
require('mini.basics').setup()
require('mini.statusline').setup()
require('mini.tabline').setup()
require('mini.surround').setup()
require('mini.ai').setup()
require('mini.pairs').setup()
require('mini.comment').setup()
require('mini.icons').setup()
require('mini.pick').setup()

-- Theme: Catppuccin Mocha
require('catppuccin').setup({ flavour = 'mocha' })
vim.cmd.colorscheme('catppuccin-mocha')

-- Always show tabline (buffer list)
vim.opt.showtabline = 2


