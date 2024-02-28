local provider = require('core.logic.provider')

-- Inspired by https://github.com/aktersnurra/minibar.nvim
local opts = {
  ["ignore-filetypes"] = {
    "help",
    "startify",
    "dashboard",
    "packer",
    "NvimTree",
    "Trouble",
    "alpha",
    "Outline",
    "lazy",
  },
  events = {
    "CursorMoved",
    "CursorHold",
    "BufWinEnter",
    "BufEnter",
    "BufFilePost",
    "InsertEnter",
    "BufWritePost",
    "TabClosed",
  },
}

local function is_nil(val)
  return ((val == nil) or (val == ""))
end

local function ignore()
  return vim.tbl_contains(opts["ignore-filetypes"], provider.get_filetype())
end

local function main()
  if (ignore() ~= true) and (is_nil(provider.get_filename()) == false) then
    local added = provider.get_git_status("added")
    local changed = provider.get_git_status("changed")
    local removed = provider.get_git_status("removed")

    -- todo make this a table
    local bar = {
      " ",
      provider.get_icon_by_filetype(provider.get_filetype()),
      "%t%m",
      "%=",
      added,
      changed,
      removed,
      "%=",
      "%c",
      " ",
      "%l/%L",
    }

    return vim.api.nvim_set_option_value("winbar", table.concat(bar, ""), { scope = "local" })
  else
    vim.opt_local.winbar = nil
    return nil
  end
end

vim.api.nvim_create_autocmd(opts.events, { callback = main })
