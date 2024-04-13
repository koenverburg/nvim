vim.g.mapleader = ","
vim.loader.enable()

require("bootstrap")
require("bootstrap.lazy")
require("core.options")
require("core.remaps")
require("core.autocmds")
require("custom.winbar")
require("custom.quickfix")

