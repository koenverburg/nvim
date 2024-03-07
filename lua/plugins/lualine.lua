require('globals')
local p = require('custom.lines.provider')

local filetype = {
  [1] = "filetype",
  padding = 0,
  colored = true,
  icon_only = true,
  disabled_buftypes = { "nvim-tree" },
}

local colors = {
  red = '#ca1243',
  grey = '#a0a1a7',
  black = '#383a42',
  white = '#f3f3f3',
  light_green = '#83a598',
  orange = '#fe8019',
  green = '#8ec07c',
}

-- local empty = require('lualine.component'):extend()

-- function empty:draw(default_highlight)
--   self.status = ''
--   self.applied_separator = ''
--   self:apply_highlights(default_highlight)
--   self:apply_section_separators()
--   return self.status
-- end

-- -- Put proper separators and gaps between components in sections
-- local function process_sections(sections)
--   for name, section in pairs(sections) do
--     local left = name:sub(9, 10) < 'x'
--     for pos = 1, name ~= 'lualine_z' and #section or #section - 1 do
--       table.insert(section, pos * 2, { empty, color = { fg = colors.white, bg = colors.white } })
--     end
--     for id, comp in ipairs(section) do
--       if type(comp) ~= 'table' then
--         comp = { comp }
--         section[id] = comp
--       end
--       comp.separator = left and { right = '' } or { left = '' }
--     end
--   end
--   return sections
-- end


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
        "require('custom.lines.provider').active_clients()"
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
  end,
}
