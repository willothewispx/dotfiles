local map = vim.keymap.set

-- ESC
map("i", "<C-c>", "<ESC>")
map("v", "<C-c>", "<ESC>")
map("t", "<C-SPACE>", "<C-\\><C-n>")
map("t", "<ESC>", "<C-\\><C-n>")

-- Disable Ex mode
map("n", "Q", "<nop>")

-- Copy/paste to/from clipboard
map("n", "<leader>y", '"+y')
map("v", "<leader>y", '"+y')
map("n", "<C-p>", '"+p')

map("n", "<leader>d", '"_d')
map("v", "<leader>d", '"_d')

-- Movements
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Quickfixlist
map("n", "<C-j>", ":cnext<CR>")
map("n", "<C-k>", ":cprev<CR>")

-- Help
map("n", "<leader>ghw", ':h <C-R>=expand("<cword>")<CR><CR>')

-- Lspsaga
map("n", "<leader>rn", "<cmd>Lspsaga rename<cr>", { silent = true })
map("n", "ga", "<cmd>Lspsaga code_action<cr>", { silent = true })
map("n", "ge", "<cmd>Lspsaga show_line_diagnostics<cr>", { silent = true })
map("n", "gj", "<cmd>Lspsaga diagnostic_jump_next<cr>", { silent = true })
map("n", "gk", "<cmd>Lspsaga diagnostic_jump_prev<cr>", { silent = true })

-- Telescope
local t = require("telescope.builtin")

map("n","<leader><space>", t.git_files)
map("n", "<leader>ff", t.find_files, { silent = true })
map("n", "<leader>b", t.buffers, { silent = true } )
map("n", "<leader>sp", t.live_grep, { silent = true } )
map(
    "n",
    "<leader>pw",
    ':lua require("telescope.builtin").grep_string({ search = vim.fn.expand("<cword>") })<CR>',
    { silent = true }
)
map("n", "<leader>ph", t.help_tags, { silent = true } )

-- Telescope/VimRC
map("n", "<leader>vrc", require("denes.telescope.functions").search_vimrc, { silent = true } )

-- Telescope/Dotfiles
map("n", "<leader>pp", require("denes.telescope.functions").search_dotfiles, { silent = true } )

-- Telescope/Project.nvim
map("n", "<leader>ps", ":Telescope projects<CR>", { silent = true } )

-- Telescope file browser
map("n", "<leader>fb", ":Telescope file_browser<CR>")

-- Harpoon
map("n", "<leader>m", require("harpoon.mark").add_file )
map("n", "<C-e>", require("harpoon.ui").toggle_quick_menu )

map("n", "<C-h>",
function()
    require("harpoon.ui").nav_file(1)
end
)
map("n", "<C-t>",
function()
    require("harpoon.ui").nav_file(2)
end
)
map("n", "<C-n>",
    function()
        require("harpoon.ui").nav_file(3)
    end
)
map("n", "<C-s>",
    function()
        require("harpoon.ui").nav_file(4)
    end
)

map("n", "<leader>tu",
    function()
        require("harpoon.term").gotoTerminal(1)
    end
)
map("n", "<leader>te",
    function()
        require("harpoon.term").gotoTerminal(2)
    end
)

map("n", "<leader>to",
    function()
        require("harpoon.tmux").gotoTerminal(1)
    end
)
map("n", "<leader>ta",
    function()
        require("harpoon.tmux").gotoTerminal(2)
    end
)

-- Nvim-compe
map("i", "<C-e>", 'compe#close("<C-e>")', { silent = true, expr = true })

-- Neogit
map("n", "<leader>gs", require("neogit").open, { silent = true } )

-- Diffviev
map("n", "<leader>gd", ":DiffviewOpen<CR>")
map("n", "<leader>gc", ":DiffviewClose<CR>")

-- Filetree
map("n", "<leader>n", require("nvim-tree").toggle, { silent = true } )

-- Hop.nvim
map("n", "<leader>hw", ":HopWord<CR>")
map("n", "<leader>hl", ":HopLine<CR>")
map("n", "<leader>hc", ":HopChar1<CR>", { silent = true })
map("n", "<leader>hp", ":HopPattern<CR>", { silent = true })

-- Undotree
map("n", "<leader>u", ":UndotreeToggle<CR>")

-- Todo-comments
map("n", "<leader>tt", ":TodoTelescope<CR>")

-- Trouble.nvim
map("n", "<leader>xx", "<cmd>Trouble<cr>", { silent = true })

-- Symbols Tree
map("n", "<leader>so", ":SymbolsOutline<CR>")
