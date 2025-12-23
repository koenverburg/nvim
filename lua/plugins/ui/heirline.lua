return {
  "rebelot/heirline.nvim",
  lazy = false,
  event = LoadOnBuffer,
  enabled = true,
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("2_plugin-configs.heirline")
  end,
}
