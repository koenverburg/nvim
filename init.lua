vim.g.mapleader = ","
vim.loader.enable()

require("0_internal.constants")
require("core.options")

require("1_bootstrap")
require("1_bootstrap.lazy")
-- require("1_bootstrap.lazier")

require("core.remaps")
-- require("core.autocmds")

require("configuration.folds")
-- require("custom.quickfix")
-- require("custom.split-terminal")
require("custom.floating-terminal")
-- require("custom.virtual-text") -- off because of nvim lint virtual text issue
require("custom.quick-actions")
require("custom.pocs.comment").setup({
  keymap = "<leader>sc", -- Optional: set a keymap
})
-- require("custom.pocs.guides").setup()
-- require("custom.winbar")
-- require("custom.statusline")

-- require("custom.pocs")
-- require("colorschemes.quiet")
-- require("tangerine").load()
