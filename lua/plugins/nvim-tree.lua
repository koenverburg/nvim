require("globals")

return {
  "nvim-tree/nvim-tree.lua",
  enabled = Is_enabled("nvim-tree"),
  keys = {
    { "<C-b>", "<cmd>NvimTreeToggle<cr>", desc = "Open Nvim Tree" },
  },
  config = function()
    require("plugin-configs.nvim-tree")
  end,
}
