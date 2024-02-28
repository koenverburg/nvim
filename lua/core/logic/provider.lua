local M = {}

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

return M
