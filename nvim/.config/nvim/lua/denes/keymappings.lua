-- astronauta.nvim
local k = require('astronauta.keymap')
local nnoremap = k.nnoremap

-- ESC
vim.api.nvim_set_keymap('i', '<C-c>', '<ESC>', {noremap = true})
vim.api.nvim_set_keymap('v', '<C-c>', '<ESC>', {noremap = true})
vim.api.nvim_set_keymap('t', '<C-SPACE>', '<C-\\><C-n>', {noremap = true})
vim.api.nvim_set_keymap('t', '<ESC>', '<C-\\><C-n>', {noremap = true})

-- Disable Ex mode
vim.api.nvim_set_keymap('n', 'Q', '<nop>', {noremap = true})

-- Copy/paste to/from clipboard
vim.api.nvim_set_keymap('n', '<leader>y', '"+y', {noremap = true})
vim.api.nvim_set_keymap('v', '<leader>y', '"+y', {noremap = true})
vim.api.nvim_set_keymap('n', '<C-p>', '"+p', {noremap = true})

vim.api.nvim_set_keymap('n', '<leader>d', '"_d', {noremap = true})
vim.api.nvim_set_keymap('v', '<leader>d', '"_d', {noremap = true})

-- Movements
vim.api.nvim_set_keymap('n', 'n', 'nzzzv', {noremap = true})
vim.api.nvim_set_keymap('n', 'N', 'Nzzzv', {noremap = true})

-- Quickfixlist
vim.api.nvim_set_keymap('n', '<C-j>', ':cnext<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<C-k>', ':cprev<CR>', {noremap = true})

-- Help
vim.api.nvim_set_keymap('n', '<leader>ghw', ':h <C-R>=expand("<cword>")<CR><CR>', {noremap = true})

-- Lspsaga
nnoremap{'ga', require('lspsaga.codeaction').code_action, {silent = true}}
nnoremap{'<leader>rn', require('lspsaga.rename').rename, {silent = true}}
nnoremap{'gh', require('lspsaga.provider').lsp_finder, {silent = true}}
nnoremap{'ge', require('lspsaga.diagnostic').show_line_diagnostics, {silent = true}}
nnoremap{'[e', require('lspsaga.diagnostic').lsp_jump_diagnostic_prev, {silent = true}}
nnoremap{']e', require('lspsaga.diagnostic').lsp_jump_diagnostic_next, {silent = true}}

-- Telescope
local t = require('telescope.builtin')

nnoremap{'<leader><space>', t.git_files, {silent = true}}
nnoremap{'<leader>b', t.buffers, {silent = true}}
nnoremap{'<leader>sp', t.live_grep, {silent = true}}
vim.api.nvim_set_keymap('n', '<leader>pw', ':lua require("telescope.builtin").grep_string({ search = vim.fn.expand("<cword>") })<CR>', {noremap = true, silent = true})
nnoremap{'<leader>ph', t.help_tags, {silent = true}}

-- Telescope/VimRC
nnoremap{'<leader>vrc', require('denes.telescope.functions').search_vimrc, {silent = true}}

-- Telescope/Dotfiles
nnoremap{'<leader>pp', require('denes.telescope.functions').search_dotfiles, {silent = true}}

-- Telescope/Notes
nnoremap{'<leader>pn', require('denes.telescope.functions').search_notes, {silent = true}}

-- Telescope/Project.nvim
nnoremap{'<leader>ps', ':Telescope projects<CR>', {silent = true}}

-- Harpoon
nnoremap{'<leader>m', require('harpoon.mark').add_file, {}}
nnoremap{'<C-e>', require('harpoon.ui').toggle_quick_menu, {}}

nnoremap{'<C-h>', function() require('harpoon.ui').nav_file(1) end, {}}
nnoremap{'<C-t>', function() require('harpoon.ui').nav_file(2) end, {}}
nnoremap{'<C-n>', function() require('harpoon.ui').nav_file(3) end, {}}
nnoremap{'<C-s>', function() require('harpoon.ui').nav_file(4) end, {}}

nnoremap{'<leader>tu', function() require('harpoon.term').gotoTerminal(1) end, {}}
nnoremap{'<leader>te', function() require('harpoon.term').gotoTerminal(2) end, {}}

-- Nvim-compe
vim.api.nvim_set_keymap('i', '<C-e>', 'compe#close("<C-e>")', {noremap = true, silent = true, expr = true})

-- Neogit
nnoremap{'<leader>gs', require('neogit').open, {silent = true}}

-- Diffviev
vim.api.nvim_set_keymap('n', '<leader>gd', ':DiffviewOpen<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>gc', ':DiffviewClose<CR>', {noremap = true})

-- Filetree
nnoremap{'<leader>n', require('nvim-tree').toggle, {silent = true}}

-- Hop.nvim
nnoremap{'<leader>hw', require'hop'.hint_words, {}}
nnoremap{'<leader>hl', require'hop'.hint_lines, {}}
nnoremap{'<leader>hc', require'hop'.hint_char1, {}}
nnoremap{'<leader>hp', require'hop'.hint_patterns, {}}

-- Undotree
vim.api.nvim_set_keymap('n', '<leader>u', ':UndotreeToggle<CR>', {noremap = true})

-- Todo-comments
vim.api.nvim_set_keymap('n', '<leader>tt', ':TodoTelescope<CR>', {noremap = true})

-- Trouble.nvim
vim.api.nvim_set_keymap("n", "<leader>xx", "<cmd>Trouble<cr>",
  {silent = true, noremap = true}
)
