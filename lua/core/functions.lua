local core = require("core.config")

local M = {}

function M.is_enabled(plugin)
  return core.plugins[plugin].enabled
end

function M.bind(mode, keys, func)
  vim.keymap.set(mode, keys, func, { noremap = true, silent = true })
end

function M.normal(key, func)
  M.bind("n", key, func)
end

function M.visual(key, func)
  M.bind("v", key, func)
end

function M.insert(key, func)
  M.bind("i", key, func)
end

function M.terminal(key, func)
  M.bind("t", key, func)
end

function M.quite()
  vim.schedule(function()
    -- require("experiments.gc").clean()
    -- vim.cmd "tabdo SymbolsOutlineClose"
    -- require("persistence").save()
    vim.cmd(":qall")
  end)
end

function M.save_and_execute()
  print("save and execute")
  local filetype = vim.bo.filetype

  if filetype == "vim" then
    vim.cmd([[silent! write]])
    vim.cmd([[source %]])
  elseif filetype == "lua" then
    vim.cmd([[silent! write]])
    vim.cmd([[luafile %]])
  end
end

local function hide_tabline()
  local total_tabs = vim.fn.tabpagenr("$")

  if total_tabs > 1 then
    vim.opt.showtabline = 2
  else
    vim.opt.showtabline = 0
  end
end

function M.hideTablineWhenSingleTab()
  hide_tabline()
  vim.api.nvim_create_autocmd({
    "BufWinEnter",
    "BufEnter",
    "BufWritePost",
    "TabNew",
    "TabClosed",
  }, { callback = hide_tabline })
end

function M.inputOrUI(opts, callback)
  opts = opts or { default = "", prompt = "prompt" }

  if not vim.ui.input then
    local value = vim.fn.input(opts.prompt .. ": ", opts.default)
    callback(value)
  else
    vim.ui.input(opts, callback)
  end
end

function M.PopUpSearch()
  local opts = {
    prompt = "Search For",
    default = "",
  }

  local proxy = function(value)
    if value == nil or value == "" then
      return
    end

    vim.cmd("/" .. value)
  end

  M.inputOrUI(opts, proxy)
end

return M
