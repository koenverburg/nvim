local keymaps = require("core.keymaps")

return {
  "phaazon/hop.nvim",
  enabled = true,
  event = LoadOnBuffer,
  keys = keymaps.get_plugin_keys("hop"),
  config = function()
    require("hop").setup()
  end,
}
