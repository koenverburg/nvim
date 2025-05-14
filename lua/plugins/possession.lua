require("globals")

return {
  "jedrzejboczar/possession.nvim",
  enabled = Is_enabled("possession"),
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  lazy = false,
  opts = {
    session_dir = vim.fn.getcwd() .. "/.possession",
  },
  config = function(_, opts)
    require("possession").setup(opts)
  end,
}
