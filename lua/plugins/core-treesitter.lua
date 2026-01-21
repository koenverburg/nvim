return {
  "nvim-treesitter/nvim-treesitter",
  lazy = true,
  enabled = true,
  version = false,
  build = ":TSUpdate",
  event = LoadOnBuffer,

  dependencies = {
    -- NOTE some bugs in these other plugins
    -- "Wansmer/treesj",
    -- "filNaj/tree-setter",
    -- "nvim-treesitter/nvim-treesitter-refactor",
    -- "nvim-treesitter/nvim-treesitter-textobjects",
    -- { "nvim-treesitter/playground", lazy = true, cmd = "TSPlaygroundToggle" },
  },

  keys = {
      { "<space>m", "<cmd>TSJToggle<cr>", "Toggle split/join" },
      { "<space>j", "<cmd>TSJJoin<cr>", "Join lines" },
      { "<space>s", "<cmd>TSJSplit<cr>", "Split lines" },
  },

  config = function()
    require("2_configs.treesitter")
  end,
}
