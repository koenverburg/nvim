require("globals")

return {
  "phaazon/hop.nvim",
  enabled = Is_enabled("hop"),
  event = LoadOnBuffer,
  keys = {
    -- { "<leader>jf", "<cmd>HopWord<cr>", desc = "Word jump" },
    { "<leader>jf", "<cmd>HopWordMW<cr>", desc = "[W]ord [J]ump" },
  },
  config = function()
    require("hop").setup()
  end,
}
