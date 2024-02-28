require('globals')

local plugin = "gruvbox"

return {
  "ellisonleao/" .. plugin .. ".nvim",
  enabled = Is_enabled(plugin),
  lazy    = false,
  opts    = {
    bold = true,
    undercurl = true,
    underline = true,
    italic = {
      folds = false,
      strings = false,
      comments = false,
      operators = false,
    },
    strikethrough = true,
    invert_signs = false,
    invert_tabline = false,
    invert_selection = false,
    invert_intend_guides = false,
    inverse = true, -- invert background for search, diffs, statuslines and errors
    contrast = "",  -- can be "hard", "soft" or empty string
    dim_inactive = false,
    transparent_mode = false,
    overrides = {},
    palette_overrides = {},
  },
  config  = function(_, opts)
    vim.cmd("set background=dark")
    require("gruvbox").setup(opts)
    vim.cmd("colorscheme gruvbox")
  end,
}
