return {
  dir = "~/code/github/nightcoder.nvim",
  lazy = false,
  enabled = false,
  config = function()
    require("nightcoder").setup()
  end,
}
