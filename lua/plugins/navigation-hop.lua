return {
  "folke/flash.nvim",
  lazy = true,
  enabled = false,
  event = LoadOnBuffer,
  opts = {},
  keys = {
    {
      "<leader>jf",
      function()
        require("flash").jump({
          pattern = [[\<]],
          search = { mode = "search", max_length = 0 },
          label = { after = { 0, 0 } },
        })
      end,
      desc = "Jump to word",
    },
    {
      "<leader>jl",
      function()
        require("flash").jump({
          pattern = "^",
          search = { mode = "search", max_length = 0, multi_window = false },
          label = { after = { 0, 0 } },
        })
      end,
      desc = "Jump to line",
    },
    {
      "<leader>jc",
      function()
        require("flash").jump({ search = { multi_window = false } })
      end,
      desc = "Jump to character",
    },
  },
}
