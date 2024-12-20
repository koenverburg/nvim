require("globals")

return {
  "folke/edgy.nvim",
  enabled = false,
  lazy = false,
  -- event = "VeryLazy",
  opts = {
    exit_when_last = false,
    -- close edgy when all windows are hidden instead of opening one of them
    -- disable to always keep at least one edgy split visible in each open section
    close_when_all_hidden = true,
    animate = {
      enabled = false,
    },
    ---@type table<Edgy.Pos, {size:integer | fun():integer, wo?:vim.wo}>
    options = {
      left = { size = 30 },
      bottom = { size = 10 },
      right = { size = 30 },
      top = { size = 10 },
    },
    left = {
      {
        title = "Aerial",
        ft = "aerial",
      },
    }, ---@type (Edgy.View.Opts|string)[]
    right = {
      {
        title = function()
          local buf_name = vim.api.nvim_buf_get_name(0) or "[No Name]"
          return vim.fn.fnamemodify(buf_name, ":t")
        end,
        ft = "Outline",
        pinned = true,
        open = "SymbolsOutlineOpen",
      },
    }, ---@type (Edgy.View.Opts|string)[]
    top = {}, ---@type (Edgy.View.Opts|string)[]
    bottom = {}, ---@type (Edgy.View.Opts|string)[]
  },
}
