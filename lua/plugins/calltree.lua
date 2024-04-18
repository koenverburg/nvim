-- marcomayer/calltree.nvim
require("globals")

return {
  "marcomayer/calltree.nvim",
  enabled = Is_enabled("calltree"),
  lazy = false,
  -- event = LoadOnBuffer,
  keys = {
    { "<space>o", "<cmd>CTPanel<cr>", desc = "Call tree toggle" },
  },
  config = function()
    require("calltree").setup()
  end,
}
