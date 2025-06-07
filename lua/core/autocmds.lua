local function augroup(name)
  return vim.api.nvim_create_augroup("conradtheprogrammer-" .. name, { clear = true })
end

local function au(typ, pattern, cmdOrFn)
  if type(cmdOrFn) == "function" then
    vim.api.nvim_create_autocmd(typ, { pattern = pattern, callback = cmdOrFn, group = group })
  else
    vim.api.nvim_create_autocmd(typ, { pattern = pattern, command = cmdOrFn, group = group })
  end
end

au("InsertEnter", nil, function()
  vim.diagnostic.enable(false)
end)

au("InsertLeave", nil, function()
  vim.diagnostic.enable(true)
end)

-- Highlight on yank
au("TextYankPost", nil, function()
  vim.highlight.on_yank({
    higroup = "IncSearch",
    timeout = 40,
  })
end)

-- wrap and check for spell in text filetypes
au("FileType", { "gitcommit", "markdown" }, function()
  vim.opt_local.wrap = true
  vim.opt_local.spell = true
end)

-- vim.api.nvim_create_autocmd('LspAttach', {
--     callback = function(ev)
--         local client = vim.lsp.get_client_by_id(ev.data.client_id)
--         if client:supports_method('textDocument/completion') then
--             vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
--         end
--     end,
-- })

vim.api.nvim_create_autocmd("LspAttach", {
  group = augroup("lsp-attach"),
  callback = function(client_id)
    local client = vim.lsp.get_client_by_id(client_id)

    if client == nil then
      return
    end

    vim.b.buf.lsp = client.name
    if client:supports_method("textDocument/documentHighlight") then
      vim.api.nvim_create_autocmd("CursorHold", "InsertLeave", function()
        vim.lsp.buf.document_highlight({ bufnr = vim.api.nvim_get_current_buf() })
      end)

      vim.api.nvim_create_autocmd("CursorMoved", "InsertEnter", function()
        vim.lsp.buf.clear_references({ bufnr = vim.api.nvim_get_current_buf() })
      end)
    end

    if client:supports_method("textDocument/inlayHint") then
      vim.keymap.set("n", "<C-h>", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = vim.api.nvim_get_current_buf() }))
      end, { buffer = vim.api.nvim_get_current_buf(), desc = "Toggle inlay hints" })
    end

    if client:supports_method("textDocument/codeLens") then
      vim.api.nvim_create_autocmd("LspProgress", "end", function()
        local bufnr = vim.api.nvim_get_current_buf()
        if bufnr == vim.api.nvim_get_current_buf() then
          vim.lsp.codelens.refresh({ bufnr = bufnr })
        end
      end)

      vim.api.nvim_create_autocmd("BufEnter", "TextChanged", "InsertLeave", function()
        local bufnr = vim.api.nvim_get_current_buf()
        vim.lsp.codelens.refresh({ bufnr = bufnr })
      end)
    end

    if client:supports_method("textDocument/foldingRange") then
      vim.o.foldmethod = "expr"
      vim.o.foldexpr = "v:lua.vim.lsp.foldexpr()"
    end

    if client:supports_method("textDocument/formatting") then
      vim.api.nvim_create_autocmd("BufWritePre", function()
        local client_id = client.id
        local bufnr = vim.api.nvim_get_current_buf()
        if not (client.settings.autoformat or vim.b.lsp.autoformat) and not (vim.g.lsp and vim.g.lsp.autoformat) then
          vim.lsp.buf.format({ bufnr = bufnr, id = client_id })
        end
      end)
    end

    if client:supports_method("textDocument/completion") then
      local name = client.name
      if name == "lua-language-server" then
        client.serverCapabilities.completionProvider.triggerCharacters = { ".", ":" }
      end

      vim.lsp.completion.enable(true, client.id, vim.api.nvim_get_current_buf() or 0, { autotrigger = true })
      -- vim.lsp.completion.enable(true, client_id, bufnr)
    end
  end,
})

-- vim.api.nvim_create_autocmd("BufRead", {
--   pattern = { "*.go", "*.ts" },
--   callback = function()
--     vim.cmd("AerialOpen")
--   end,
-- })

-- vim.api.nvim_create_autocmd("BufEnter", {
--   group = augroup("cockpit"),
--   callback = function()
--     local r = vim.fn.tabpagebuflist()
--     print(vim.inspect(r), #r)
--     if #r > 1 and #r < 3 then
--       vim.cmd("AerialOpen")
--     end
--   end,
-- })

-- vim.api.nvim_create_autocmd('LspAttach', {
--   group = augroup('lsp'),
--   callback = function(e)
--     local opts = { buffer = e.buf }
--     vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
--     vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
--     vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
--     vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
--     vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
--     vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
--     vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
--     vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
--     vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
--     vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
--   end
-- })
