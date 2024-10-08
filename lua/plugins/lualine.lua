require("globals")
local p = require("custom.lines.provider")

local filetype = {
  [1] = "filetype",
  padding = 1,
  colored = true,
  icon_only = true,
  disabled_buftypes = { "nvim-tree" },
}

local colors = {
  red = "#ca1243",
  grey = "#a0a1a7",
  black = "#383a42",
  white = "#f3f3f3",
  light_green = "#83a598",
  orange = "#fe8019",
  green = "#8ec07c",
  bg = "#151515",
  bg1 = "#242B2E",
}

local plugin = "lualine"
return {
  "nvim-lualine/" .. plugin .. ".nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  enabled = false, -- Is_enabled(plugin),
  lazy = false,
  opts = {
    options = {
      icons_enabled = true,
      theme = "auto",
      -- theme = "no-clown-fiesta",
      -- theme = "minimal",
      component_separators = "",
      section_separators = { left = "", right = "" },
      -- section_separators = { left = " ", right = " " },
      disabled_filetypes = {
        statusline = {},
        winbar = {},
      },
      ignore_focus = {},
      globalstatus = true,
      always_divide_middle = true,
      refresh = {
        winbar = 1000,
        tabline = 1000,
        statusline = 1000,
      },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { "" },
      lualine_x = { "" },
      lualine_y = {},
      lualine_z = {},
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {},
  },
  config = function(_, opts)
    local empty = require("lualine.component"):extend()

    function empty:draw(default_highlight)
      self.status = ""
      self.applied_separator = ""
      self:apply_highlights(default_highlight)
      self:apply_section_separators()
      return self.status
    end

    local function process_sections(sections)
      for name, section in pairs(sections) do
        local left = name:sub(9, 10) < "x"
        for pos = 1, name ~= "lualine_z" and #section or #section - 1 do
          table.insert(section, pos * 2, { empty, color = { fg = colors.bg1, bg = colors.bg1 } })
        end
        for id, comp in ipairs(section) do
          if type(comp) ~= "table" then
            comp = { comp }
            section[id] = comp
          end
          comp.separator = left and { right = " " } or { left = " " }
        end
      end
      return sections
    end

    local sections = process_sections({
      lualine_a = {
        "mode",
      },
      lualine_b = {
        p.branch(),
        filetype,
        "filename",
      },
      lualine_c = {},
      lualine_x = {
        "",
      },
      lualine_y = {
        "require('custom.lines.provider').formatters()",
      },
      lualine_z = {
        "require('custom.lines.provider').active_clients()",
      },
    })
    opts.sections = sections
    require("lualine").setup(opts)
    -- set fillchars+=stl:\ ,stlnc:\ "
    -- vim.api.nvim_set_hl(0, "StatusLineNC", {})
    -- vim.api.nvim_set_hl(0, "NvimTreeStatusLineNC", {})
    -- vim.api.nvim_set_hl(0, "StatusLine", { bg = "#171717" })
    -- vim.api.nvim_set_hl(0, "StatusLine", { bg = "#151515" })
    -- vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "#151515" })
  end,
}
