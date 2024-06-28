local M = {}
local signs = require("core.config").signs
local utils = require("core.utils")
local helpers = require("core.helpers")

function M.get_filetype()
  return vim.bo.filetype
end

function M.get_filename()
  return vim.fn.expand("%:t")
end

function M.get_icon_by_filetype(ft)
  local ok, icons = pcall(require, "nvim-web-devicons")

  if not ok then
    return ""
  end

  if not ft then
    return ""
  end

  local icon, color = icons.get_icon_by_filetype(ft)

  if not icon then
    return ""
  end

  return "%#" .. color .. "#" .. icon .. "%#Normal#" .. " "
end

function M.get_git_status(type)
  local chars = {
    added = "",
    changed = "~",
    removed = "",
  }

  local colors = {
    added = "%#GitSignsAdd#",
    changed = "%#GitSignsChange#",
    removed = "%#GitSignsDelete#",
  }

  if not vim.b.gitsigns_status_dict then
    return ""
  end

  if not vim.b.gitsigns_status_dict[type] then
    return ""
  end

  if vim.b.gitsigns_status_dict[type] > 0 then
    return colors[type] .. chars[type] .. vim.b.gitsigns_status_dict[type] .. "%#Normal#" .. " "
  end

  return ""

  -- {
  --   added = 4,
  --   changed = 0,
  --   removed = 0,
  --   head = "main",
  --   gitdir = "/Users/koenverburg/code/github/dotfiles/.git",
  --   root = "/Users/koenverburg/code/github/dotfiles"
  -- }
end

function M.branch()
  return {
    [1] = "b:gitsigns_head",
    padding = 1,
    icon = signs.git,
    -- color = {
    --   fg = "DevIconGitLogo",
    --   bg = "Normal",
    -- },
    icons_enabled = true,
    disabled_buftypes = { "nvim-tree" },
  }
end

function M.active_clients()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = bufnr })

  local value = utils.dim(signs.orb)

  local names = {}
  for _, client in pairs(clients) do
    table.insert(names, client.name)
  end

  if #names > 0 then
    -- return utils.dim('lsp: ' .. table.concat(names, ', '))
    value = signs.filledOrb .. " " .. table.concat(names, ", ")
  end
  return value
end

function M.diagnostic()
  local norm = "%#Normal#"
  local info = helpers.get_diagnostic("info")
  local hint = helpers.get_diagnostic("hint")
  local warning = helpers.get_diagnostic("warning")
  local error = helpers.get_diagnostic("error")

  local segments = {
    norm,
    info,
    " ",
    hint,
    " ",
    warning,
    " ",
    error,
    " ",
    norm,
  }

  return table.concat(segments, "")
end

local function flatten_formatters(formatters)
  local flat = {}
  for _, name in ipairs(formatters) do
    if type(name) == "string" then
      table.insert(flat, name)
    else
      for _, f in ipairs(flatten_formatters(name)) do
        table.insert(flat, f)
      end
    end
  end
  return flat
end

function M.formatters()
  local empty = utils.dim(signs.orb)

  local ok, conform = pcall(require, "conform")
  if not ok then
    return empty
  end

  local formatters_by_ft = conform.formatters_by_ft
  if not formatters_by_ft[vim.bo.filetype] then
    return empty
  end

  local formatters = {}
  for _, formatter in ipairs(flatten_formatters(formatters_by_ft[vim.bo.filetype])) do
    local details = conform.get_formatter_info(formatter)
    if details.available then
      table.insert(formatters, details.name)
    end
  end

  local line = signs.filledOrb .. " "

  if #formatters == 1 then
    return line .. table.concat(formatters, "")
  elseif #formatters > 1 then
    return line .. table.concat(formatters, ", ")
  end

  return empty
end

return M
