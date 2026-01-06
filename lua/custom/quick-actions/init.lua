local M = {}

-- local function float(part)
--   return "Trouble " .. part .. " win.type=split"
-- end
--
-- local function Item(name, cmd)
--   return {
--     label = name,
--     action = function()
--       vim.cmd(cmd)
--     end,
--   }
-- end

local function one_shot_ide()
  return {
    label = "one-shot",
    action = function()
      vim.cmd("Trouble lsp_type_definitions toggle focus=false")
      vim.cmd("Trouble lsp_definitions toggle focus=false")
      vim.cmd("Trouble lsp_references toggle focus=false")
      vim.cmd("Trouble symbols toggle focus=false")
      vim.cmd("Trouble diagnostics toggle focus=false")
    end,
  }
end

local function find_and_replace()
  return {
    label = "Find N Replace - ",
    action = function()
      require("grug-far").open({ engine = "astgrep", transient = true })
    end,
  }
end

local menu_options = {
  find_and_replace(),
  one_shot_ide(),
  {
    label = "Fold All",
    action = function()
      vim.cmd([[%foldc]])
    end,
  },
  -- Item("References", float("lsp_references")),
  {
    label = "Mock Function",
    action = function()
      vim.cmd("MockFunction")
    end,
  },
  {
    label = "Remove unused imports",
    action = function()
      vim.cmd("VtsExec remove_unused_imports")
    end,
  },
  {
    label = "Remove unused (variables)",
    action = function()
      vim.cmd("VtsExec remove_unused")
    end,
  },
  {
    label = "Add missing imports",
    action = function()
      vim.cmd("VtsExec add_missing_imports")
    end,
  },
  {
    label = "Namu workspace",
    action = function()
      require("namu.namu_workspace").show()
    end,
  },
  {
    label = "Namu symbols",
    action = function()
      require("namu.namu_symbols").show()
    end,
  },
  {
    label = "Namu diagnostics",
    action = function()
      require("namu.namu_diagnostics").show()
    end,
  },
  {
    label = "Namu workspace diagnostics",
    action = function()
      require("namu.namu_diagnostics").show_workspace_diagnostics()
    end,
  },
  {
    label = "Namu call",
    action = function()
      require("namu.namu_callhierarchy").show()
    end,
  },
}

function M.show_menu()
  vim.ui.select(menu_options, {
    prompt = "Select action: ",
    format_item = function(item)
      return item.label
    end,
  }, function(choice)
    if choice and choice.action then
      choice.action()
    end
  end)
end

vim.keymap.set("n", "<space><space>", M.show_menu, { desc = "Show cursor menu" })
