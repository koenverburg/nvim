require("globals")

return {
  "anuvyklack/hydra.nvim",
  enabled = Is_enabled("hydra"),
  lazy = false,
  event = LoadOnBuffer,
  opts = {
    name = "Change / Resize Window",
    mode = { "n" },
    body = "<leader>w",
    config = {
      -- color = "pink",
    },
    heads = {
      -- move between windows
      { "h", "<C-w>h" },
      { "j", "<C-w>j" },
      { "k", "<C-w>k" },
      { "l", "<C-w>l" },

      -- resizing window
      { "H", "<C-w>3<" },
      { "L", "<C-w>3>" },
      { "K", "<C-w>3+" },
      { "J", "<C-w>3-" },

      -- equalize window sizes
      { "e", "<C-w>=" },

      -- close active window
      { "Q", ":q<cr>" },
      { "<C-q>", ":q<cr>" },

      -- exit this Hydra
      { "q", nil, { exit = true, nowait = true } },
      { ";", nil, { exit = true, nowait = true } },
      { "<Esc>", nil, { exit = true, nowait = true } },
    },
  },
  config = function(_, opts)
    local hydra = require("hydra")
    hydra(opts)
  end,
}
