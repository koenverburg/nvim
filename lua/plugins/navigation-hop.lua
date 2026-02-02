return {
  "phaazon/hop.nvim",
  enabled = true,
  event = LoadOnBuffer,
  keys = {
    { "<leader>jf", "<cmd>HopWordMW<cr>", desc = "Jump to word" },
    { "<leader>jl", "<cmd>HopLineStar<cr>", desc = "Jump to line" },
    { "<leader>jc", "<cmd>HopChar1<cr>", desc = "Jump to character" },
  },
  config = function()
    require("hop").setup()
  end,
}
