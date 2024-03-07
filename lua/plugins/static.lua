require("globals")

local plugin = "static"

return {
  {
    -- dir = "~/code/github/static.nvim",
    "koenverburg/static.nvim",
    enabled = Is_enabled(plugin),
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
