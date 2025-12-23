return {
  "folke/noice.nvim",
  enabled = true,
  lazy = false,
  -- event = LoadOnBuffer,
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require("2_plugin-configs.noice")
  end,
}
