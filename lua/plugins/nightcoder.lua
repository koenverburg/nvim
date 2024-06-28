require("globals")

return {
  dir = "~/code/github/nightcoder.nvim",
  lazy = false,
  enabled = Is_enabled("nightcoder"),
  config = function()
    require("nightcoder").setup()
  end,
}
