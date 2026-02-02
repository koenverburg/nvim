return {
  "MagicDuck/grug-far.nvim",
  lazy = true,
  enabled = true,
  keys = {
    { "<leader>fr", "<cmd>GrugFar<cr>", desc = "Find and Replace - GrugFar" },
  },
  config = function()
    require("grug-far").setup()
  end,
}
