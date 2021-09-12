-- ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
-- ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
-- ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
-- ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
-- ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
-- ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝

-- Author: Denes Stolte
-- Link:   https://gitlab.com/WillOtheWispX/nvim

-- Set leader key
vim.g.mapleader = ','
vim.g.maplocalleader = ','

-- Load packer.nvim files
require('denes.plugins')

-- Load options
require('denes.options')

-- Load keymappings
require('denes.keymappings')

-- Load lsp configuration
require('denes.lsp')

-- THEME
require('denes.colors')
