return {
  "comfysage/evergarden",
  enabled = false,
  lazy = false,
  config = function()
    require("evergarden").setup({
      override_terminal = true,
      contrast_dark = "hard", -- 'hard'|'medium'|'soft'
      transparent_background = true,
      style = {
        tabline = { reverse = true, color = "green" },
        search = { reverse = false, inc_reverse = true },
        types = { italic = false },
        keyword = { italic = false },
        comment = { italic = false },
        sign = { highlight = false },
      },
      overrides = {}, -- add custom overrides
    })
    vim.cmd("colorscheme evergarden")
  end,
}
