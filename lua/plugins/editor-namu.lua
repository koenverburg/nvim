return {
  "bassamsdata/namu.nvim",
  enabled = true,
  lazy = true,
  -- event = LoadOnBuffer,
  config = function()
    require("namu").setup({
      -- Enable the modules you want
      namu_symbols = {
        enable = true,
        options = {}, -- here you can configure namu
      },
      -- Optional: Enable other modules if needed
      ui_select = { enable = false }, -- vim.ui.select() wrapper
    })
  end,
}
