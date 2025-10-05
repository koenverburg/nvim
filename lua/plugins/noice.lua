require("globals")

return {
  "folke/noice.nvim",
  enabled = Is_enabled("noice"),
  lazy = false,
  -- event = LoadOnBuffer,
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require("plugin-configs.noice")
  end,
}
