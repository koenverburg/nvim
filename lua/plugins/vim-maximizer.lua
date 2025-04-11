require("globals")

return {
  "szw/vim-maximizer",
  enabled = Is_enabled("vim-maximizer"),
  keys = {
    { "<leader>sm", "<cmd>MaximizerToggle<CR>", desc = "Maximize/minimize a split" },
  },
}
