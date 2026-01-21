vim.g.mapleader = ","
vim.loader.enable()

vim.g.loaded_netrw = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_python3_provider = 0

require("0_internal.constants")

require("0_internal.qof-commands")

require("1_bootstrap")
require("1_bootstrap.lazy")

require("core.options")

require("core.remaps")
-- require("core.autocmds")

require("configuration.folds")

-- require("custom.quickfix")
-- require("custom.split-terminal")
-- require("custom.floating-terminal")
-- require("custom.virtual-text") -- off because of nvim lint virtual text issue
require("custom.quick-actions")
require("custom.pocs.commit").setup({
  keymap = "<leader>sc", -- Optional: set a keymap
})
-- require("custom.pocs.guides").setup()
-- require("custom.winbar")
-- require("custom.statusline")

-- require("custom.pocs")
-- require("colorschemes.quiet")
-- require("tangerine").load()
