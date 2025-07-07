vim.g.mapleader = ","
vim.loader.enable()

require("bootstrap")
require("bootstrap.lazy")

require("core.options")
require("core.remaps")
require("core.autocmds")

require("custom.quickfix")
require("custom.split-terminal")
require("custom.floating-terminal")
require("custom.virtual-text")
-- require("custom.pocs.guides").setup()
-- require("custom.winbar")
-- require("custom.statusline")

require("custom.pocs")

-- themes
-- require("tangerine").load()
