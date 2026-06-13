local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 8

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

local function copy_relative_path()
  local path = vim.fn.expand("%:.")

  if path == "" then
    vim.notify("No file path for current buffer", vim.log.levels.WARN)
    return
  end

  vim.fn.setreg("+", path)
  vim.notify("Copied " .. path)
end

vim.keymap.set("n", "<C-n>", "<C-i>", { desc = "Jump forward" })
vim.keymap.set("n", "<leader>cn", "<cmd>cnext<cr>", { desc = "Next quickfix item" })
vim.keymap.set("n", "<leader>cp", "<cmd>cprev<cr>", { desc = "Previous quickfix item" })
vim.keymap.set("n", "<leader>yp", copy_relative_path, { desc = "Yank relative file path" })
vim.keymap.set("n", "q:", "<Nop>", { desc = "Disable command-line window" })
vim.keymap.set("c", "<C-f>", "<Nop>", { desc = "Disable command-line window" })
