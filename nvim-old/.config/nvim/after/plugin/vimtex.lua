-- Recognize .tex files as latex files
vim.g.tex_flavor = 'latex'

-- Neovim remote
vim.g.vimtex_compiler_progname = 'nvr'

-- Settings
vim.g.vimtex_syntax_enabled = 1
vim.g.vimtex_quickfix_mode = 2
vim.g.vimtex_quickfix_autoclose_after_keystrokes = 1

-- Disable warnings based on regexp
vim.g.vimtex_quickfix_ignore_filters = {'Marginpar on page', 'Overfull', 'Underfull'}

-- PDF viewer
if vim.fn.has('macunix') == 1 then
  vim.g.vimtex_view_method = 'skim'
  vim.g.vimtex_view_general_options = '-r @line @pdf @tex'
else
  vim.g.vimtex_view_method = 'zathura'
end
