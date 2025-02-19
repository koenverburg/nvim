require("globals")
local config = require("core.config")

return {
  "cdmill/neomodern.nvim",
  enabled = Is_enabled("neomodern"),
  lazy = false,
  priority = 1000,
  config = function()
    require("neomodern").setup({
      style = "roseprime",
      -- UI options --
      ui = {
        telescope = "bordered", -- choose between 'borderless' or 'bordered'
        cmp_itemkind_reverse = false, -- reverse item kind highlights in cmp menu
        -- colored_docstrings = true, -- if true, docstrings will be highlighted like strings, otherwise they will be highlighted like comments
        -- plain = false, -- don't set background for search
        -- show_eob = true, -- show the end-of-buffer tildes

        -- Plugins Related --
        plain_float = true,
        cmp = {
          plain = true,
        },
        -- lualine = {
        --   bold = false,
        --   plain = false, -- use a less distracting lualine. note: works best when no lualine separators are used
        -- },
        diagnostics = {
          darker = true, -- darker colors for diagnostic
          undercurl = true, -- use undercurl for diagnostics
          background = true, -- use background color for virtual text
        },
      },
      highlights = {
        Search = { fg = config.colors.black, bg = config.colors.yellow },
        -- TelescopeSelection = { fg = config.colors.yellow },
        TelescopeSelectionCaret = { fg = config.colors.yellow },
      },
    })
    require("neomodern").load()
    vim.cmd([[colorscheme roseprime]])
  end,
}
