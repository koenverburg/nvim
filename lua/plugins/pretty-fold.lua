require('globals')

return {
  "anuvyklack/pretty-fold.nvim",
  enabled = Is_enabled("pretty-fold"),
  event = LoadOnBuffer,
  -- lazy = false,
  config = function()
    require("pretty-fold").setup({
      -- fill_char = '-',
    })
  end,
}
