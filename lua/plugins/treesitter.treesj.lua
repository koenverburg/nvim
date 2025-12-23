local keymaps = require("core.keymaps")

return {
  "Wansmer/treesj",
  keys = keymaps.get_plugin_keys("treesj"),
  enabled = true,
  -- event = LoadOnBuffer,
  dependencies = { "nvim-treesitter/nvim-treesitter" }, -- if you install parsers with `nvim-treesitter`
  config = function()
    require("treesj").setup()
  end,
}
