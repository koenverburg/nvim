require("globals")

return {
  "chrisgrieser/nvim-spider",
  enabled = Is_enabled("nvim-spider"),
  version = "*", -- Use for stability; omit to use `main` branch for the latest features
  keys = {
    {
      "w",
      "<cmd>lua require('spider').motion('w')<CR>",
      mode = { "n", "o", "x" },
    },
    {
      "e",
      "<cmd>lua require('spider').motion('e')<CR>",
      mode = { "n", "o", "x" },
    },
    {
      "b",
      "<cmd>lua require('spider').motion('b')<CR>",
      mode = { "n", "o", "x" },
    },
    -- ...
  },
  event = "VeryLazy",
  config = function()
    -- default values
    require("spider").setup({
      skipInsignificantPunctuation = true,
      subwordMovement = true,
      customPatterns = {}, -- check "Custom Movement Patterns" in the README for details
    })
  end,
}
