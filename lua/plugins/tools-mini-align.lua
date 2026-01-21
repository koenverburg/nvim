return {
  "nvim-mini/mini.align",
  version = "*",
  enabled = true,
  event = LoadOnBuffer,
  config = function()
    require("mini.align").setup()
  end,
}
