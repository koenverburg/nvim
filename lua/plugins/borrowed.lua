require("globals")

return {
  "myypo/borrowed.nvim",
  enabled = Is_enabled("borrowed"),
  lazy = false,
  priority = 1000,

  -- version = "^0", -- Optional: avoid upgrading to breaking versions
  config = function()
    -- require("borrowed").setup({ ... }) -- Optional: only has to be called to change settings
    -- vim.cmd("colorscheme mayu") -- OR
    vim.cmd("colorscheme shin")
  end,
}
