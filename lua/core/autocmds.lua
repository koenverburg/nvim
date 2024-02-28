local function augroup(name)
  return vim.api.nvim_create_augroup("conradtheprogrammer-" .. name, { clear = true })
end

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    vim.highlight.on_yank({
      higroup = 'IncSearch',
      timeout = 40,
    })
  end,
})

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("wrap_spell"),
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- autocmd('LspAttach', {
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