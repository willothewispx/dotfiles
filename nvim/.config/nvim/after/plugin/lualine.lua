local tokyonight = require("tokyonight.colors").setup()

local c = {
    diff = {
        add = tokyonight.git.add,
        change = tokyonight.git.change,
        delete = tokyonight.git.delete,
    },
}

require("lualine").setup({
    options = {
        -- theme = 'gruvbox_material',
        -- theme = 'tokyonight',
        seperator = { left = "", right = "" },
        icons_enabled = true,
    },
    sections = {
        lualine_a = { { "mode", fmt = string.upper } },
        -- lualine_b = {'branch', {'diff', color_added = c.diff.add, color_modified = c.diff.change, color_removed = c.diff.delete}},
        lualine_b = {
            "branch",
            {
                "diff",
                colored = true,
                diff_color = {
                    added = { fg = c.diff.add },
                    modified = { fg = c.diff.change },
                    removed = { fg = c.diff.delete },
                },
            },
        },
        lualine_c = { { "filename", file_status = true }, { "diagnostics", sources = { "nvim_diagnostic" } } },
        lualine_x = { "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
    },
    extensions = { "fugitive", "nvim-tree", "quickfix" },
})
