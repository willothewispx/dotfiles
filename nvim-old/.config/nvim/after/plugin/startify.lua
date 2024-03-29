vim.g.startify_custom_header = {
    "███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
    "████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
    "██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
    "██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
    "██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
    "╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
}

vim.g.startify_lists = {
    { ["type"] = "bookmarks", ["header"] = { "bookmarks" } },
}

local home = os.getenv("HOME")
local dotfiles = os.getenv("DOTFILES")

vim.g.startify_bookmarks = {
    { ["n"] = home .. "/Nextcloud/orgmode/notes.org" },
    { ["i"] = dotfiles .. "/nvim/.config/nvim/init.lua" },
    { ["z"] = dotfiles .. "/zsh/.zshrc" },
    { ["k"] = dotfiles .. "/kitty-mac/.config/kitty/kitty.conf" },
    { ["t"] = dotfiles .. "/tmux/.tmux.conf" },
    { ["c"] = home .. "/dev/cv/cv.tex" },
}
