require('nvim-treesitter.configs').setup{
  -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  ensure_installed = {
    'go',
    'python',
    'lua',
    'typescript',
    'svelte',
    'latex',
    'bash',
    'jsonc',
    'regex',
    'toml',
    'html',
    'css'
  },
  highlight = {
    enable = true,
  },
  indent = {
    enable = true
  },
  refactor = {
    highlight_definitions = {enable = true},
    highlight_current_scope = {enable = false},
  }
}
