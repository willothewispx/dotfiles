vim.g.tokyonight_style = "night"

-- Change the "hint" color to the "orange" color, and make the "error" color bright red
vim.g.tokyonight_colors = { hint = "orange", error = "#ff0000" }

-- vim.g.tokyonight_transparent = true
vim.g.tokyonight_transparent_sidebar = true

vim.g.tokyonight_italic_comments = true

vim.cmd("colorscheme tokyonight")

require("lualine").setup({
    options = {
        theme = "tokyonight",
    },
})
