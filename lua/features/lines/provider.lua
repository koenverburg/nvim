local M = {}
local utils = require('features.lines.utils')
local helpers = require('features.lines.helpers')
local signs = require('core.config').signs

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
    color = 'DevIconGitLogo',
    icons_enabled = true,
    disabled_buftypes = { "nvim-tree" }
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
    value = utils.dim(signs.filledOrb .. " " .. table.concat(names, ", "))
  end
  return value
end

local function fmtHi(hi)
  return "%#" .. hi .. "#"
end

function M.diagnostic()
  local norm = fmtHi("Normal")
  local info = helpers.get_diagnostic('info')
  local hint = helpers.get_diagnostic('hint')
  local warning = helpers.get_diagnostic('warning')
  local error = helpers.get_diagnostic('error')

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

return M
