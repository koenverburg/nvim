-- require("custom.pocs.hints").setup()
require("custom.pocs.commit").setup({
  keymap = "<leader>sc", -- Optional: set a keymap
})

require('custom.pocs.refactor').setup_keymaps()
