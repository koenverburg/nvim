return {
  "xzbdmw/colorful-menu.nvim",
  enabled = true,
  events = LoadOnBuffer,
  config = function()
    require("2_configs.config-colorful-menu")
  end,
}
