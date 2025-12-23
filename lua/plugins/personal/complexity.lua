return {
  dir = "~/code/github/complexity.nvim",
  -- "koenverburg/complexity.nvim",
  event = LoadOnBuffer,
  enabled = false,
  config = function()
    require("complexity").setup()
  end,
}
