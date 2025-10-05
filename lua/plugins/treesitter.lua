require("globals")

return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    build = ":TSUpdate",
    event = LoadOnBuffer,
    enabled = Is_enabled("treesitter"),

    dependencies = {
      "filNaj/tree-setter",
      "nvim-treesitter/nvim-treesitter-refactor",
      { "nvim-treesitter/playground", lazy = true, cmd = "TSPlaygroundToggle" },
      { "nvim-treesitter/nvim-treesitter-textobjects", lazy = true },
    },

    config = function()
      require("plugin-configs.treesitter")
    end,
  },
}
