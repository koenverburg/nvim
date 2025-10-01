return {
  "folke/snacks.nvim",
  enabled = vim.env.PROF,
  config = function()
    local Snacks = require("snacks")
    -- Toggle the profiler
    Snacks.toggle.profiler():map("<leader>pp")
    -- Toggle the profiler highlights
    Snacks.toggle.profiler_highlights():map("<leader>ph")
  end,

  opts = {
    bigfile = { enabled = false },
    dashboard = { enabled = false },
    explorer = { enabled = false },
    indent = { enabled = false },
    input = { enabled = false },
    picker = { enabled = false },
    notifier = { enabled = false },
    quickfile = { enabled = false },
    scope = { enabled = false },
    scroll = { enabled = false },
    statuscolumn = { enabled = false },
    words = { enabled = false },
  },
  keys = {
    {
      "<leader>ps",
      function()
        local Snacks = require("snacks")
        Snacks.profiler.scratch()
      end,
      desc = "Profiler Scratch Bufer",
    },
  },
}
