return {
  "phaazon/hop.nvim",
  enabled = true,
  event = LoadOnBuffer,
  keys = { "<leader>jf", "<cmd>HopWordMW<cr>", desc = "[W]ord [J]ump" },
  config = function()
    require("hop").setup()
  end,
}
