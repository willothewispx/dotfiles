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
require('mini.files').setup({
  -- Show preview of file/directory under cursor
  preview = true,
  -- Use as default file explorer instead of netrw
  use_as_default_explorer = true,
  -- Customize window options
  windows = {
    preview = true,
    width_focus = 60,
    width_preview = 60,
  },
})
require('mini.diff').setup({
  view = {
    style = 'sign',
    signs = {
      add = '│',
      change = '│',
      delete = '│',
    },
  },
  options = {
    wrap_goto = false,
    algorithm = 'histogram',
    indent_heuristic = true,
    linematch = 60,
  },
})

-- Theme: Catppuccin Mocha with transparency
require('catppuccin').setup({
  flavour = 'mocha',
  transparent_background = true,
})
vim.cmd.colorscheme('catppuccin-mocha')

-- Additional transparency settings
vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
vim.api.nvim_set_hl(0, 'NormalNC', { bg = 'none' })
vim.api.nvim_set_hl(0, 'CursorLine', { bg = 'none' })
vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#89b4fa', bg = 'none', bold = true })

-- Always show tabline (buffer list)
vim.opt.showtabline = 2


