local config = require("core.config")
local M = {}

M.default = {
  color_devicons = true,
  sorting_strategy = "ascending",
  selection_caret = config.signs.caret .. " ",
  prompt_prefix = " " .. config.signs.telescope .. " ",
  borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
  layout_config = {
    height = 0.75,
    width = 0.9,
  },
}

function M.wide(position)
  return {
    layout_config = {
      prompt_position = position,
      height = function(_, _, max_lines)
        return math.floor(max_lines * 0.95)
      end,
    },
  }
end

function M.small_dropdown(position)
  return {
    layout_config = {
      width = 0.6,
      height = 0.6,
      prompt_position = position,
    },
  }
end

return M
