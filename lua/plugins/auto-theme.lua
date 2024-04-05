require("globals")

return {
  "f-person/auto-dark-mode.nvim",
  lazy = false,
  enabled = Is_enabled("auto-theme"),
  dependencies = {
    "aktersnurra/no-clown-fiesta.nvim",
    "ellisonleao/gruvbox.nvim",
  },
  config = {
    update_interval = 1000,
    set_dark_mode = function()
      -- require("no-clown-fiesta").setup({
      --   transparent = false, -- Enable this to disable the bg color
      --   styles = {
      --     -- You can set any of the style values specified for `:h nvim_set_hl`
      --     comments = {},
      --     keywords = {},
      --     functions = {},
      --     variables = {},
      --     type = { bold = true },
      --     lsp = { underline = true },
      --   },
      -- })
      -- vim.cmd("set background=dark")
      -- vim.cmd([[colorscheme no-clown-fiesta]])
      require("gruvbox").setup({
        terminal_colors = true, -- add neovim terminal colors
        undercurl = true,
        underline = true,
        bold = true,
        italic = {
          strings = true,
          emphasis = true,
          comments = true,
          operators = false,
          folds = true,
        },
        strikethrough = true,
        invert_selection = false,
        invert_signs = false,
        invert_tabline = false,
        invert_intend_guides = false,
        inverse = true, -- invert background for search, diffs, statuslines and errors
        contrast = "", -- can be "hard", "soft" or empty string
        palette_overrides = {},
        overrides = {},
        dim_inactive = false,
        transparent_mode = false,
      })
      vim.cmd("set background=dark")
      vim.cmd("colorscheme gruvbox")
    end,
    set_light_mode = function()
      require("gruvbox").setup({
        terminal_colors = true, -- add neovim terminal colors
        undercurl = true,
        underline = true,
        bold = true,
        italic = {
          strings = true,
          emphasis = true,
          comments = true,
          operators = false,
          folds = true,
        },
        strikethrough = true,
        invert_selection = false,
        invert_signs = false,
        invert_tabline = false,
        invert_intend_guides = false,
        inverse = true, -- invert background for search, diffs, statuslines and errors
        contrast = "", -- can be "hard", "soft" or empty string
        palette_overrides = {},
        overrides = {},
        dim_inactive = false,
        transparent_mode = false,
      })
      vim.cmd("set background=light")
      vim.cmd("colorscheme gruvbox")
    end,
  },
}
