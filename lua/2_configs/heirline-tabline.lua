local utils = require("heirline.utils")

-- -----------------------------------------------------------------------
-- Helper:  read a tab‑page “label” that the user may set
-- -----------------------------------------------------------------------
local function get_tab_label(tabpage)
  -- A user can give a tab a custom name with:
  --   :lua vim.api.nvim_set_tabvar(tabpage, "name", "My label")
  local name = vim.fn.gettabvar(tabpage, "name")
  return name ~= "" and name or "Tab " .. vim.fn.tabpagewinnr(tabpage, 0)
end

-- -----------------------------------------------------------------------
-- Component that will be rendered for each tab page
-- -----------------------------------------------------------------------
local Tabpage = {
  -- What the tab will display
  provider = function(self)
    local idx = self.tabnr -- tab number (1,2,…)
    local label = get_tab_label(self.tabpage)
    local panes = #vim.api.nvim_tabpage_list_wins(self.tabpage) -- number of windows in that tab

    return string.format("%d %s (%d)", idx, label, panes)
  end,

  -- Highlight: use the normal TabLine colours, but highlight the current tab
  hl = function(self)
    return self.is_active and "TabLineSel" or "TabLine"
  end,

  -- Optional: make the whole tab clickable → go to that tab
  on_click = { callback = function(_, _, _, _, _) end },
}

-- -----------------------------------------------------------------------
-- Build the whole tab‑line (only when we have ≥2 tabs)
-- -----------------------------------------------------------------------
local TabPages = {
  condition = function()
    return #vim.api.nvim_list_tabpages() >= 2
  end,
  { provider = "%=" }, -- push the tabs to the right
  utils.make_tablist(Tabpage), -- create the list from the Tabpage component
}

-- local TabLine = { TabPages }

local M = {}

M.TabLine = TabPages

return M
