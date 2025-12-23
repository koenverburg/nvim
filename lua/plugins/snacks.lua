return {
  "folke/snacks.nvim",
  enabled = vim.env.PROF,
  config = function()
    if vim.env.PROF then
      local Snacks = require("snacks")
      -- Toggle the profiler
      Snacks.toggle.profiler():map("<leader>pp")
      -- Toggle the profiler highlights
      Snacks.toggle.profiler_highlights():map("<leader>ph")
    end
  end,
  opts = {
    -- stylua: ignore start
    bigfile      = { enabled = false },
    dashboard    = { enabled = false },
    explorer     = { enabled = false },
    input        = { enabled = false },
    picker       = { enabled = false },
    notifier     = { enabled = false },
    quickfile    = { enabled = false },
    scope        = { enabled = false },
    scroll       = { enabled = false },
    statuscolumn = { enabled = false },
    words        = { enabled = false },
    indent       = { enabled = false }
,
    -- stylua: ignore end
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
