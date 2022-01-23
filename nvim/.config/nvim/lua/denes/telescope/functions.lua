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

M.search_personal_notes = function()
    require("telescope.builtin").find_files({
        prompt_title = "< Personal Notes >",
        cwd = "$HOME/Nextcloud/Neorg/personal/",
    })
end

M.search_work_notes = function()
    require("telescope.builtin").find_files({
        prompt_title = "< Work Notes >",
        cwd = "$HOME/Nextcloud/Neorg/work/",
    })
end

return M
