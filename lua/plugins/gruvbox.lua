require("globals")

return {
  "ellisonleao/gruvbox.nvim", -- theme
  lazy = false,
  enabled = Is_enabled("gruvbox"),
  config = function()
    require("plugin-configs.gruvbox")
  end,
}
