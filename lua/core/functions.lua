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

function M.telescope_map(key, func)
  M.bind("n", key, func)
end

local lsp_map = function(mode, key, action)
  local command = string.format("<cmd>lua %s()<cr>", action)
  vim.api.nvim_buf_set_keymap(0, mode, key, command, { noremap = true, silent = true })
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

function M.on_attach(client, bufnr)
  client.server_capabilities.semanticTokensProvider = nil

  if client.name == "ls_ts" then
    vim.lsp.inlay_hint.enable()
    vim.api.nvim_set_hl(0, "LspInlayHint", { link = "comment" })
  end

  if client.name == "ls_ts" or client.name == "sumneko_lua" or client.name == "gopls" then
    -- vim.lsp.inlay_hint(bufnr, true)
    client.server_capabilities.document_formatting = false
  end

  -- if M.is_enabled('nvim-navbuddy') then
  --   local navbuddy = require("nvim-navbuddy")
  --   navbuddy.attach(client, bufnr)
  -- end

  -- local ih = require("inlay-hints")
  -- if ih then
  --   ih.on_attach(client, bufnr)
  -- end

  -- require("lsp_signature").on_attach({
  --   bind = true,
  --   handler_opts = {
  --     border = "rounded",
  --   },
  -- }, bufnr)

  -- if client.server_capabilities.documentSymbolProvider then
  --   require("nvim-navic").attach(client, bufnr)
  -- end

  -- M.bind("n", "<leader>lf", [[ <cmd>lua vim.lsp.buf.format({async=true})<cr> ]])

  lsp_map("n", "<leader>sd", "vim.diagnostic.open_float")
  lsp_map("n", "K", "require('pretty_hover').hover()")
  -- lsp_map("n", "K", "vim.lsp.buf.hover")
  -- lsp_map('n', '<C-K>', "vim.lsp.buf.signature_help")
  lsp_map("n", "gD", "vim.lsp.buf.declaration")
  lsp_map("n", "gd", "vim.lsp.buf.definition")
  lsp_map("n", "<c-]>", "vim.lsp.buf.definition")
  lsp_map("n", "gi", "vim.lsp.buf.implementation")
  lsp_map("n", "goc", "vim.lsp.buf.outgoing_calls")

  lsp_map("n", "<leader>ca", "vim.lsp.buf.code_action")
  lsp_map("i", "<leader>ca", "vim.lsp.buf.code_action")
end

return M
