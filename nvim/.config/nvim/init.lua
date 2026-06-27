vim.loader.enable()

vim.g.mapleader = ","
vim.g.maplocalleader = ","

require("config.options")
require("config.filetypes")
local rocks = require("config.rocks")
require("config.lazy")
rocks.refresh_runtimepath()
