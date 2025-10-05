require("globals")

return {
  "xzbdmw/colorful-menu.nvim",
  enabled = Is_enabled("colorful-menu"),
  events = LoadOnBuffer,
  config = function()
    require("plugin-configs.colorful-menu")
  end,
}
