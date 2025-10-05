require("globals")

local signs = require("core.config").signs

local spinners = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
local spinner_index = 1

local colors = {
  red = "#ca1243",
  grey1 = "#a0a1a7",
  black = "#383a42",
  white = "#f3f3f3",
  light_green = "#83a598",
  orange = "#fe8019",
  green = "#8ec07c",
  bg = "#171717",
  fg = "#D0D0D0",
  gray = "#373737",
}

local theme = {
  normal = {
    a = { fg = colors.white, bg = colors.black, gui = "bold" },
    b = { fg = colors.white, bg = colors.black },
    c = { fg = colors.white, bg = colors.black },

    x = { fg = colors.white, bg = colors.black },
    y = { fg = colors.white, bg = colors.black },
    z = { fg = colors.white, bg = colors.black },
  },
  insert = { a = { fg = colors.white, bg = colors.black, gui = "bold" } },
  visual = { a = { fg = colors.white, bg = colors.black, gui = "bold" } },
  command = { a = { fg = colors.white, bg = colors.black, gui = "bold" } },
  replace = { a = { fg = colors.white, bg = colors.black, gui = "bold" } },
  inactive = {
    a = { fg = colors.white, bg = colors.black, gui = "bold" },
    b = { fg = colors.white, bg = colors.black },
    c = { fg = colors.white, bg = colors.black },

    x = { fg = colors.white, bg = colors.black },
    y = { fg = colors.white, bg = colors.black },
    z = { fg = colors.white, bg = colors.black },
  },
}

local function search_result()
  if vim.v.hlsearch == 0 then
    return ""
  end
  local last_search = vim.fn.getreg("/")
  if not last_search or last_search == "" then
    return ""
  end
  local searchcount = vim.fn.searchcount({ maxcount = 9999 })
  return last_search .. "(" .. searchcount.current .. "/" .. searchcount.total .. ")"
end

local function modified()
  if vim.bo.modified then
    return "+"
  elseif vim.bo.modifiable == false or vim.bo.readonly == true then
    return "-"
  end
  return ""
end

local function lsp_spinner()
  local msgs = vim.lsp.util.get_progress_messages()
  if #msgs == 0 then
    return ""
  end
  spinner_index = (spinner_index % #spinners) + 1
  return spinners[spinner_index] .. " LSP"
end

local function lsp_clients()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then
    return signs.orb
  end
  return signs.filledOrb
    .. " "
    .. table.concat(
      vim.tbl_map(function(c)
        return c.name
      end, clients),
      ", "
    )
end

-- local function formatters()
--   local names = {}
--   local buf_ft = vim.bo.filetype
--
--   -- conform.nvim (optional, comment this block if not using)
--   local ok2, conform = pcall(require, "conform")
--   if ok2 then
--     local cfg = conform.formatters_by_ft[buf_ft] or {}
--     for _, f in ipairs(cfg) do
--       table.insert(names, type(f) == "string" and f or f.name)
--     end
--   end
--
--   if vim.tbl_isempty(names) then
--     return signs.orb
--   end
--   return signs.filledOrb .. " " .. table.concat(names, ", ")
-- end

local function trunc(trunc_width, trunc_len, hide_width, no_ellipsis)
  return function(str)
    local win_width = vim.o.columns
    if hide_width and win_width < hide_width then
      return ""
    elseif trunc_width and trunc_len and win_width < trunc_width and #str > trunc_len then
      return str:sub(1, trunc_len) .. (no_ellipsis and "" or "...")
    end
    return str
  end
end

vim.defer_fn(function()
  vim.fn.timer_start(100, function()
    require("lualine").refresh()
  end, { ["repeat"] = -1 })
end, 0)

return {
  "nvim-lualine/lualine.nvim",
  enabled = Is_enabled("lualine"),
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = LoadOnBuffer,
  lazy = false,
  config = function()
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
          table.insert(section, pos * 2, { empty, color = { fg = colors.red, bg = colors.bg } })
        end

        for id, comp in ipairs(section) do
          if type(comp) ~= "table" then
            comp = { comp }
            section[id] = comp
          end
          comp.separator = left and { right = "" } or { left = "" }
        end
      end
      return sections
    end

    require("lualine").setup({
      options = {
        theme = theme,
        component_separators = "",
        section_separators = { left = "", right = "" },
        globalstatus = true,
      },
      sections = process_sections({
        lualine_a = { { "mode" } },
        lualine_b = {
          { "branch", icon = signs.git },
        },
        lualine_c = {
          {
            "filename",
            path = 1,
            padding = {
              left = 1,
              right = 0,
            },
            symbols = { modified = "  ", readonly = "  " },
          },
          {
            "filetype",
            icon_only = true,
            separator = "",
            padding = { left = 1, right = 0 },
          },
        },
        lualine_x = {
          " ",
          --   { "encoding" },
          --   { "fileformat" },
        },
        lualine_y = {
          -- formatters,
          { "diff", symbols = { added = "+", modified = "~", removed = "-" } },
        },
        lualine_z = {
          lsp_spinner,
          lsp_clients,
          --   { "location" },
        },
      }),
      inactive_sections = {
        -- lualine_c = { "%f %y %m" },
        -- lualine_x = {},
      },
    })
  end,
}
