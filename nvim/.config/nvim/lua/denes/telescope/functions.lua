local M = {}

M.search_vimrc = function()
    require("telescope.builtin").find_files({
        prompt_title = "< VimRC >",
        cwd = "$DOTFILES/nvim/.config/nvim",
        hidden = true,
    })
end

M.search_dotfiles = function()
    require("telescope.builtin").git_files({
        prompt_title = "< Dotfiles >",
        cwd = "$DOTFILES",
        hidden = true,
    })
end

return M
