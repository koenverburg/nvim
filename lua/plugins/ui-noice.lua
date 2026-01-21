-- TODO do I readlly need this plugin for
-- an "in the middle of the screen cmdline thingy"
-- maybe ask ai to create a an standalone version of this.

return {
  "folke/noice.nvim",
  enabled = true,
  lazy = false,
  -- event = LoadOnBuffer,
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require("2_configs.noice")
  end,
}
