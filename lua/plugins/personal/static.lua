require("globals")

return {
  {
    -- "koenverburg/static.nvim",
    dir = "~/code/github/static.nvim",
    enabled = false, -- Is_enabled("personal/static"),
    lazy = false,
    keys = {
      { "<leader>fi", "<cmd>lua require('static.treesitter').fold_imports()<cr>", desc = "Static - fold imports" },
      { "<leader>fr", "<cmd>lua require('static.treesitter').region()<cr>", desc = "Static - fold regions" },
    },
    config = function()
      require("static").setup()
    end,
  },
}
