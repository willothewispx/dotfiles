require 'nvim-tree'.setup {
    update_focused_file = {
        enable = true,
        update_cwd = true,
        ignore_list = {},
    },
    renderer = {
        indent_markers = {
            enable = true,
            inline_arrows = true,
            icons = {
                corner = "└",
                edge = "│",
                item = "│",
                bottom = "─",
                none = " ",
            },
        },
    },
}
