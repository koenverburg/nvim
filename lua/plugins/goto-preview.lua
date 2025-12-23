local keymaps = require("core.keymaps")

return {
  "rmagatti/goto-preview",
  dependencies = { "rmagatti/logger.nvim" },
  enabled = true,
  event = LoadOnBuffer,
  config = true, -- necessary as per https://github.com/rmagatti/goto-preview/issues/88
  keys = keymaps.get_plugin_keys("goto_preview"),
}
