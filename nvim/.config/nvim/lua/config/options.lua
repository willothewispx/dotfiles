local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.cursorline = true

opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2

opt.ignorecase = true
opt.smartcase = true

opt.splitbelow = true
opt.splitright = true

local undodir = vim.fn.stdpath("state") .. "/undo"

opt.undofile = true
opt.undodir = undodir
opt.swapfile = false

vim.fn.mkdir(undodir, "p")

opt.timeoutlen = 300

opt.clipboard:append("unnamedplus")

vim.keymap.set("n", "<C-n>", "<C-i>", { desc = "Jump forward" })
vim.keymap.set("n", "q:", "<Nop>", { desc = "Disable command-line window" })
vim.keymap.set("c", "<C-f>", "<Nop>", { desc = "Disable command-line window" })
