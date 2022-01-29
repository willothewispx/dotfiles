-- astronauta.nvim
local k = require("astronauta.keymap")
local nnoremap = k.nnoremap
local map = vim.api.nvim_set_keymap

-- ESC
map("i", "<C-c>", "<ESC>", { noremap = true })
map("v", "<C-c>", "<ESC>", { noremap = true })
map("t", "<C-SPACE>", "<C-\\><C-n>", { noremap = true })
map("t", "<ESC>", "<C-\\><C-n>", { noremap = true })

-- Disable Ex mode
map("n", "Q", "<nop>", { noremap = true })

-- Copy/paste to/from clipboard
map("n", "<leader>y", '"+y', { noremap = true })
map("v", "<leader>y", '"+y', { noremap = true })
map("n", "<C-p>", '"+p', { noremap = true })

map("n", "<leader>d", '"_d', { noremap = true })
map("v", "<leader>d", '"_d', { noremap = true })

-- Movements
map("n", "n", "nzzzv", { noremap = true })
map("n", "N", "Nzzzv", { noremap = true })

-- Quickfixlist
map("n", "<C-j>", ":cnext<CR>", { noremap = true })
map("n", "<C-k>", ":cprev<CR>", { noremap = true })

-- Help
map("n", "<leader>ghw", ':h <C-R>=expand("<cword>")<CR><CR>', { noremap = true })

-- Lspsaga
map("n", "<leader>rn", "<cmd>Lspsaga rename<cr>", { silent = true, noremap = true })
map("n", "ga", "<cmd>Lspsaga code_action<cr>", { silent = true, noremap = true })
map("n", "ge", "<cmd>Lspsaga show_line_diagnostics<cr>", { silent = true, noremap = true })
map("n", "gj", "<cmd>Lspsaga diagnostic_jump_next<cr>", { silent = true, noremap = true })
map("n", "gk", "<cmd>Lspsaga diagnostic_jump_prev<cr>", { silent = true, noremap = true })

-- Telescope
local t = require("telescope.builtin")

nnoremap({ "<leader><space>", t.git_files, { silent = true } })
nnoremap({ "<leader>ff", t.find_files, { silent = true } })
nnoremap({ "<leader>b", t.buffers, { silent = true } })
nnoremap({ "<leader>sp", t.live_grep, { silent = true } })
map(
    "n",
    "<leader>pw",
    ':lua require("telescope.builtin").grep_string({ search = vim.fn.expand("<cword>") })<CR>',
    { noremap = true, silent = true }
)
nnoremap({ "<leader>ph", t.help_tags, { silent = true } })

-- Telescope/VimRC
nnoremap({ "<leader>vrc", require("denes.telescope.functions").search_vimrc, { silent = true } })

-- Telescope/Dotfiles
nnoremap({ "<leader>pp", require("denes.telescope.functions").search_dotfiles, { silent = true } })

-- Telescope/Notes
nnoremap({ "<leader>nn", require("denes.telescope.functions").search_personal_notes, { silent = true } })
nnoremap({ "<leader>nw", require("denes.telescope.functions").search_work_notes, { silent = true } })

-- Telescope/Project.nvim
nnoremap({ "<leader>ps", ":Telescope projects<CR>", { silent = true } })

-- Telescope file browser
map("n", "<leader>fb", ":Telescope file_browser<CR>", { noremap = true })

-- Harpoon
nnoremap({ "<leader>m", require("harpoon.mark").add_file, {} })
nnoremap({ "<C-e>", require("harpoon.ui").toggle_quick_menu, {} })

nnoremap({
    "<C-h>",
    function()
        require("harpoon.ui").nav_file(1)
    end,
    {},
})
nnoremap({
    "<C-t>",
    function()
        require("harpoon.ui").nav_file(2)
    end,
    {},
})
nnoremap({
    "<C-n>",
    function()
        require("harpoon.ui").nav_file(3)
    end,
    {},
})
nnoremap({
    "<C-s>",
    function()
        require("harpoon.ui").nav_file(4)
    end,
    {},
})

nnoremap({
    "<leader>tu",
    function()
        require("harpoon.term").gotoTerminal(1)
    end,
    {},
})
nnoremap({
    "<leader>te",
    function()
        require("harpoon.term").gotoTerminal(2)
    end,
    {},
})

nnoremap({
    "<leader>to",
    function()
        require("harpoon.tmux").gotoTerminal(1)
    end,
    {},
})
nnoremap({
    "<leader>ta",
    function()
        require("harpoon.tmux").gotoTerminal(2)
    end,
    {},
})

-- Nvim-compe
map("i", "<C-e>", 'compe#close("<C-e>")', { noremap = true, silent = true, expr = true })

-- Neogit
nnoremap({ "<leader>gs", require("neogit").open, { silent = true } })

-- Diffviev
map("n", "<leader>gd", ":DiffviewOpen<CR>", { noremap = true })
map("n", "<leader>gc", ":DiffviewClose<CR>", { noremap = true })

-- Filetree
nnoremap({ "<leader>n", require("nvim-tree").toggle, { silent = true } })

-- Hop.nvim
map("n", "<leader>hw", ":HopWord<CR>", { noremap = true })
map("n", "<leader>hl", ":HopLine<CR>", { noremap = true })
map("n", "<leader>hc", ":HopChar1<CR>", { noremap = true, silent = true })
map("n", "<leader>hp", ":HopPattern<CR>", { noremap = true, silent = true })

-- Undotree
map("n", "<leader>u", ":UndotreeToggle<CR>", { noremap = true })

-- Todo-comments
map("n", "<leader>tt", ":TodoTelescope<CR>", { noremap = true })

-- Trouble.nvim
map("n", "<leader>xx", "<cmd>Trouble<cr>", { silent = true, noremap = true })

-- Symbols Tree
map("n", "<leader>so", ":SymbolsOutline<CR>", { noremap = true })
