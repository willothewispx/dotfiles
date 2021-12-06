local opt = vim.opt

opt.number = true
opt.relativenumber = true

local indent = 4

opt.expandtab = true
opt.tabstop = indent
opt.shiftwidth = indent
opt.softtabstop = indent
opt.shiftround = true

opt.showmode = false

opt.hidden = true

opt.ignorecase = true
opt.smartcase = true

opt.cursorline = true

opt.textwidth = 80
opt.colorcolumn = "+1"
opt.signcolumn = "yes"

opt.breakindent = true
opt.showbreak = string.rep(" ", 3) -- Make it so that long lines wrap smartly
opt.linebreak = true

opt.scrolloff = 10

opt.swapfile = false

local home = os.getenv("HOME")
opt.undodir = home .. "/.nvim/undodir"
opt.undofile = true

opt.mouse = "n"

opt.updatetime = 1000

opt.completeopt = "menuone,noselect"

opt.formatoptions = opt.formatoptions
    - "a" -- Auto formatting is BAD.
    - "t" -- Don't auto format my code. I got linters for that.
    + "c" -- In general, I like it when comments respect textwidth
    + "q" -- Allow formatting comments w/ gq
    - "o" -- O and o, don't continue comments
    + "r" -- But do continue when pressing enter.
    + "n" -- Indent past the formatlistpat, not underneath it.
    + "j" -- Auto-remove comments if possible.
    - "2" -- I'm not in gradeschool anymore

-- set joinspaces
opt.joinspaces = false -- Two spaces and grade school, we're done
