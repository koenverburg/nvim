require('globals')
local p = require('features.lines.provider')
local signs = require('core.config').signs

local diagnostics = {
  [1] = "diagnostics",
  sources = { "nvim_diagnostic" },
  sections = { "info", "hint", "error", "warn" },
  symbols = {
    info = signs.info .. " ",
    hint = signs.hint .. " ",
    error = signs.error .. " ",
    warn = signs.warn .. " "
  },
  padding = 0,
  colored = true,
  always_visible = true,
  update_in_insert = false,
  disabled_buftypes = { "nvim-tree" },
}

local filetype = {
  [1] = "filetype",
  padding = 0,
  colored = true,
  icon_only = true,
  disabled_buftypes = { "nvim-tree" },
}

local plugin = "lualine"
return {
  "nvim-lualine/" .. plugin .. ".nvim",
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  enabled      = Is_enabled(plugin),
  lazy         = false,
  opts         = {
    options = {
      icons_enabled = true,
      theme = 'no-clown-fiesta',
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
      disabled_filetypes = {
        statusline = {},
        winbar = {},
      },
      ignore_focus = {},
      always_divide_middle = true,
      globalstatus = true,
      refresh = {
        statusline = 1000,
        tabline = 1000,
        winbar = 1000,
      }
    },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = {
        p.branch(), 'filename', filetype,
      },
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {
        "require('features.lines.provider').active_clients()"
      }
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { '' },
      lualine_x = { '' },
      lualine_y = {},
      lualine_z = {}
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {}
  },
  config       = function(_, opts)
    require("lualine").setup(opts)
    vim.cmd([[ hi clear StatusLine ]])
  end,
}
