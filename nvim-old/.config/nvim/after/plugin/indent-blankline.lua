require("indent_blankline").setup({
    show_current_context = true,
    show_current_context_start = true,

    -- indent_blankline_context_patterns = {
    --     "class",
    --     "return",
    --     "function",
    --     "method",
    --     "^if",
    --     "^while",
    --     "jsx_element",
    --     "^for",
    --     "^object",
    --     "^table",
    --     "block",
    --     "arguments",
    --     "if_statement",
    --     "else_clause",
    --     "jsx_element",
    --     "jsx_self_closing_element",
    --     "try_statement",
    --     "catch_clause",
    --     "import_statement",
    --     "operation_type",
    -- },

    show_end_of_line = true,
})

-- vim.g.indent_blankline_char = '▏'
--
-- vim.g.indent_blankline_filetype_exclude = {'help'}
-- vim.g.indent_blankline_buftype_exclude = {'terminal'}
--
-- vim.g.indent_blankline_show_current_context = true
-- vim.g.indent_blankline_context_patterns = {'class', 'function', 'method', '^if', '^while', '^for'}
--
-- vim.g.indent_blankline_show_trailing_blankline_indent = false
