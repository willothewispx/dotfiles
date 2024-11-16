require("github-theme").setup({
  theme_style = 'dark_default',
  -- function_style = 'italic',
  sidebars = {'qf', 'packer', 'terminal', 'nvim_tree'}
})

require("lualine").setup({
  options = {
    theme = "github"
  }
})
