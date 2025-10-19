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
require('mini.map').setup({
  integrations = {
    require('mini.map').gen_integration.builtin_search(),
    require('mini.map').gen_integration.diagnostic(),
    require('mini.map').gen_integration.diff(),
  },
  symbols = {
    encode = require('mini.map').gen_encode_symbols.dot('4x2'),
  },
  window = {
    side = 'right',
    width = 15,
    winblend = 0,
  },
})

-- Neo-tree file explorer (VS Code-like sidebar)
require('neo-tree').setup({
  close_if_last_window = false,
  popup_border_style = 'rounded',
  enable_git_status = true,
  enable_diagnostics = true,
  window = {
    position = 'left',
    width = 35,
  },
  filesystem = {
    filtered_items = {
      visible = false,
      hide_dotfiles = false,
      hide_gitignored = false,
    },
    follow_current_file = {
      enabled = true,
    },
  },
})

-- Toggleterm for terminal access
require('toggleterm').setup({
  size = 20,
  open_mapping = [[<c-/>]],
  hide_numbers = true,
  shade_terminals = true,
  shading_factor = 2,
  start_in_insert = true,
  insert_mappings = true,
  terminal_mappings = true,
  persist_size = true,
  direction = 'float',
  close_on_exit = true,
  shell = vim.o.shell,
  float_opts = {
    border = 'curved',
    winblend = 0,
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

-- Auto-open minimap on startup
vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    require('mini.map').open()
  end,
})


