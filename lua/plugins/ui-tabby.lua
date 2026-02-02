local core = require("core.config")

local space = " "

local label_left = space
local label_right = space

-- local function hl(name)
--   local ok = vim.fn.nvim_get_hl_by_name(name)
--   return ok or {}
-- end

local function filter_wins(win)
  if win.buf().name() ~= "[No Name]" then
    return win
  end
end

-- print(vim.inspect(hl("TabLineSel")))

return {
  "nanozuki/tabby.nvim",
  lazy = true,
  enabled = true,
  event = LoadOnBuffer,
  config = function()
    local theme = {
      -- fill = "TabLineFill",
      fill = { bg = "#000000" },
      head = { fg = "#b46958", bg = "#000000", style = "bold" },

      current_tab = "TabLineSel",

      tab = "Comment",
      win = "Comment",
    }

    require("tabby").setup({
      line = function(line)
        return {
          {
            { label_left, hl = theme.head },
          },

          line.tabs().foreach(function(tab)
            local hl = tab.is_current() and theme.current_tab or theme.tab
            local name = tab.name()
            local index = string.find(name, "%[%d")
            local tab_name = index and string.sub(name, 1, index - 1) or name

            return {
              tab.is_current() and core.signs.filledOrb or core.signs.orb,

              tab_name,

              tab.close_btn(""),

              line.sep(space, theme.win, theme.fill),

              hl = hl,
              margin = space,
            }
          end),

          line.spacer(),

          line.wins_in_tab(line.api.get_current_tab()).filter(filter_wins).foreach(function(win)
            return {
              win.is_current() and core.signs.filledOrb or core.signs.orb,

              win.buf_name(),

              line.sep(space, theme.win, theme.fill),

              hl = theme.win,
              margin = space,
            }
          end),

          { label_right, hl = theme.head },
          hl = theme.fill,
        }
      end,
      -- option = {}, -- setup modules' option,
    })
  end,
}
