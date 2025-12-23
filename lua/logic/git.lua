local M = {}

local empty = {
  added = 0,
  removed = 0,
  changed = 0,
}

M.icons = { removed = "-", changed = "~", added = "+" }

function M.get_diff_from_buffer(buf)
  local dict = vim.b[buf].gitsigns_status_dict

  if not dict then
    return empty
  end

  local has_changes = dict.added ~= 0 or dict.removed ~= 0 or dict.changed ~= 0

  if not has_changes then
    return empty
  end

  return {
    added = dict.added,
    removed = dict.removed,
    changed = dict.changed,
  }
end

return M
