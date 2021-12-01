require('nvim-treesitter.configs').setup{
    -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    ensure_installed = {
        'bash',
        'css',
        'dockerfile',
        'go',
        'html',
        'javascript',
        'jsonc',
        'latex',
        'lua',
        'php',
        'python',
        'regex',
        'svelte',
        'toml',
        'typescript',
        'yaml',
    },
    highlight = {
        enable = true,
    },
    indent = {
        enable = true,
    },
    refactor = {
        highlight_definitions = {enable = true},
        highlight_current_scope = {enable = false},
    },
    textobjects = {
        select = {
            enable = true,
            -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,
            keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner"
            }
        },
        move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
                [']]'] = '@function.outer'
            },
            goto_next_end = {
                [']['] = '@function.outer'
            },
            goto_previous_start = {
                ['[['] = '@function.outer'
            },
            goto_previous_end = {
                ['[]'] = '@function.outer'
            }
        }
    },
}
