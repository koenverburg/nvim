require("globals")

return {
  "akinsho/toggleterm.nvim",
  enabled = Is_enabled("toggleterm"),
  version = "*",
  config = function()
    require("toggleterm").setup()
  end,
}
