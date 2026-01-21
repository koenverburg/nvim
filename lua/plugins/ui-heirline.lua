return {
  "rebelot/heirline.nvim",
  lazy = false,
  enabled = true,
  event = LoadOnBuffer,
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("2_configs.heirline")
  end,
}
