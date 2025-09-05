local M = {}

local menu_options = {
  {
    label = "Remove unused imports",
    action = function()
      vim.cmd("VtsExec remove_unused_imports")
    end
  },
  {
    label = "Remove unused (variables)",
    action = function()
      vim.cmd("VtsExec remove_unused")
    end
  },
  {
    label = "Add missing imports",
    action = function()
      vim.cmd("VtsExec add_missing_imports")
    end
  },
  {
    label = "Namu workspace",
    action = function()
      vim.cmd("Namu workspace")
    end
  },
  {
    label = "Namu symbols",
    action = function()
      vim.cmd("Namu symbols")
    end
  },
  {
    label = "Namu diagnostics",
    action = function()
      vim.cmd("Namu diagnostics")
    end
  },
  {
    label = "Namu call",
    action = function()
      vim.cmd("Namu call both")
    end
  }
}

function M.show_menu()
  vim.ui.select(menu_options, {
    prompt = 'Select action: ',
    format_item = function(item)
      return item.label
    end,
  }, function(choice)
    if choice and choice.action then
      choice.action()
    end
  end)
end

vim.keymap.set('n', '<space><space>', M.show_menu, { desc = 'Show cursor menu' })
