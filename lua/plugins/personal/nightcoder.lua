require("globals")

return {
  dir = "~/code/github/nightcoder.nvim",
  lazy = false,
  enabled = Is_enabled("personal/nightcoder"),
  config = function()
    require("nightcoder").setup()
  end,
}
