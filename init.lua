vim.g.mapleader = ","
vim.loader.enable()

require("0_internal.constants")

require("0_internal.qof-commands")

require("1_bootstrap")
require("1_bootstrap.lazy")

require("core.options")
require("core.commands")

require("core.remaps")
require("core.autocmds")

-- require("custom.quickfix")
-- require("custom.split-terminal")
-- require("custom.floating-terminal")
-- require("custom.virtual-text") -- off because of nvim lint virtual text issue
require("custom.quick-actions")
-- require("custom.pocs.guides").setup()
-- require("custom.winbar")
-- require("custom.statusline")

-- require("custom.pocs")
-- require("colorschemes.quiet")
-- require("tangerine").load()
