return {
  "nvim-treesitter/nvim-treesitter",
  version = false,
  build = ":TSUpdate",
  lazy = false,
  event = LoadOnBuffer,
  enabled = true,

  dependencies = {
    "filNaj/tree-setter",
    "nvim-treesitter/nvim-treesitter-refactor",
    { "nvim-treesitter/playground", lazy = true, cmd = "TSPlaygroundToggle" },
    { "nvim-treesitter/nvim-treesitter-textobjects", lazy = true },
  },

  config = function()
    require("2_plugin-configs.treesitter")
  end,
}
