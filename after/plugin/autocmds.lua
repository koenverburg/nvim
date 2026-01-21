local function augroup(name)
  return vim.api.nvim_create_augroup("conradtheprogrammer-" .. name, { clear = true })
end

local function au(typ, pattern, cmdOrFn, group_name)
  local group = augroup(group_name or "default")
  if type(cmdOrFn) == "function" then
    vim.api.nvim_create_autocmd(typ, { pattern = pattern, callback = cmdOrFn, group = group })
  else
    vim.api.nvim_create_autocmd(typ, { pattern = pattern, command = cmdOrFn, group = group })
  end
end

-- Highlight on yank
au("TextYankPost", nil, function()
  vim.highlight.on_yank({
    higroup = "IncSearch",
    timeout = 40,
  })
end, "highlight-yank")

-- wrap and check for spell in text filetypes
au("FileType", { "gitcommit", "markdown" }, function()
  vim.opt_local.wrap = true
  vim.opt_local.spell = true
end, "text-filetypes")

vim.api.nvim_create_autocmd("LspAttach", {
  group = augroup("lsp-attach"),
  callback = function(ev)
    -- require("custom.virtual-text") -- off because of nvim lint virtual text issue

    local client = vim.lsp.get_client_by_id(ev.data.client_id)

    if client == nil then
      return
    end

    vim.b.lsp = client.name

    if client:supports_method("textDocument/documentHighlight") then
      local highlight_group = augroup("lsp-highlight")
      vim.api.nvim_create_autocmd({ "CursorHold", "InsertLeave" }, {
        buffer = ev.buf,
        group = highlight_group,
        callback = function()
          vim.lsp.buf.document_highlight()
        end,
      })

      vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter" }, {
        buffer = ev.buf,
        group = highlight_group,
        callback = function()
          vim.lsp.buf.clear_references()
        end,
      })
    end

    -- NOTE: none of my current configured lsp clients support this
    if client:supports_method("textDocument/codeLens") then
      local codelens_group = augroup("lsp-codelens")
      vim.api.nvim_create_autocmd("LspProgress", {
        buffer = ev.buf,
        group = codelens_group,
        callback = function()
          if vim.api.nvim_get_current_buf() == ev.buf then
            vim.lsp.codelens.refresh({ bufnr = ev.buf })
          end
        end,
      })

      vim.api.nvim_create_autocmd({ "BufEnter", "TextChanged", "InsertLeave" }, {
        buffer = ev.buf,
        group = codelens_group,
        callback = function()
          vim.lsp.codelens.refresh({ bufnr = ev.buf })
        end,
      })
    end

    -- if client:supports_method("textDocument/completion") then
    -- client.server_capabilities.completionProvider.triggerCharacters = { ".", ":" }
    -- vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    -- end
  end,
})
