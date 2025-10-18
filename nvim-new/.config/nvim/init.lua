vim.g.mapleader = ','
vim.g.maplocalleader = ','

-- Bootstrap mini.deps (bundled in mini.nvim)
local path_package = vim.fn.stdpath('data') .. '/site'
local mini_path = path_package .. '/pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.fn.system({ 'git', 'clone', '--filter=blob:none', 'https://github.com/nvim-mini/mini.nvim', mini_path })
end
vim.opt.rtp:prepend(mini_path)

local deps = require('mini.deps')
local add = deps.add

-- Plugins
add({ source = 'nvim-mini/mini.nvim' })
add({ source = 'neovim/nvim-lspconfig' })
add({ source = 'williamboman/mason.nvim' })
add({ source = 'williamboman/mason-lspconfig.nvim' })
add({ source = 'nvim-treesitter/nvim-treesitter' })
add({ source = 'catppuccin/nvim' })

-- Load config modules
require('config.options')
require('config.keymaps')
require('config.ui')
require('config.lsp')


