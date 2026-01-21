local map = vim.keymap.set

for i = 1, 8 do
  map({ "n", "t" }, "<Leader>" .. i, "<Cmd>tabnext " .. i .. "<CR>")
end

vim.keymap.set("n", ";", ":", { desc = "Remap ; to :" })
vim.keymap.set("i", "jk", "<esc>", { desc = "Remap jk to esc" })

-- Terminal mode navigation (needs to be set after terminal plugins load)
vim.keymap.set("t", "<C-h>", "<C-\\><C-N><C-w>h", { desc = "Move to left window from terminal" })
vim.keymap.set("t", "<C-j>", "<C-\\><C-N><C-w>j", { desc = "Move to bottom window from terminal" })
vim.keymap.set("t", "<C-k>", "<C-\\><C-N><C-w>k", { desc = "Move to top window from terminal" })
vim.keymap.set("t", "<C-l>", "<C-\\><C-N><C-w>l", { desc = "Move to right window from terminal" })

-- Visual mode specific mappings that might conflict if set too early
vim.keymap.set({"n", "v"}, "H", "^", { desc = "Go to first non-blank character" })
vim.keymap.set({"n", "v"}, "L", "g_", { desc = "Go to last non-blank character" })
vim.keymap.set("v", "p", "\"_dP", { desc = "Paste without yanking" })
vim.keymap.set("n", "-", "<cmd>split<cr>", { desc = "Horizontal split" })
vim.keymap.set("n", "|", "<cmd>vsplit<cr>", { desc = "Vertical split" })

-- Move lines in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Move lines in normal mode
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })

-- Move lines in insert mode
vim.keymap.set("i", "<A-j>", "<Esc>:m .+1<CR>==gi", { desc = "Move line down" })
vim.keymap.set("i", "<A-k>", "<Esc>:m .-2<CR>==gi", { desc = "Move line up" })

-- Better window resizing
vim.keymap.set("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

vim.keymap.set("n", "<space>f",  "za",                                   { desc = "Toggle fold" })
vim.keymap.set("n", "<space>-", "<cmd>split<cr><c-w>j<cmd>Telescope git_files<cr>", { desc = "Horizontal split + git files" })
vim.keymap.set("n", "<space>|", "<cmd>vsplit<cr><c-w>l<cmd>Telescope git_files<cr>", { desc = "Vertical split + git files" })
vim.keymap.set("n", "<space>fr","%s/\\<<C-r><C-w>\\>//g<Left><Left>",  { desc = "Find & replace word" })
vim.keymap.set("n", "<space>sl","<cmd>set invlist<cr>",                  { desc = "Toggle listchars" })

-- Leader‑prefixed
vim.keymap.set("n", "<leader>q",  "<cmd>lua require('core.functions').quite()<cr>",   { desc = "Quick quit" })
vim.keymap.set("n", "<leader><space>", "<cmd>nohlsearch<cr>",                 { desc = "Clear search highlight" })
vim.keymap.set("n", "<leader>i",  function()
    vim.lsp.inlay_hint.enable(
      not vim.lsp.inlay_hint.is_enabled({ bufnr = vim.api.nvim_get_current_buf() })
    )
  end, { desc = "Toggle inlay hints" })

vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>",          { desc = "Find files" })
vim.keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>",          { desc = "Recent files" })
vim.keymap.set("n", "<leader>fs", "<cmd>write<cr>",                        { desc = "Save file" })
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<cr>",                      { desc = "Delete buffer" })
vim.keymap.set("n", "<leader>bn", "<cmd>bnext<cr>",                        { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bp", "<cmd>bprevious<cr>",                    { desc = "Previous buffer" })

vim.keymap.set("n", "<leader>wh", "<c-w>h",                               { desc = "Move to left window" })
vim.keymap.set("n", "<leader>wj", "<c-w>j",                               { desc = "Move to bottom window" })
vim.keymap.set("n", "<leader>wk", "<c-w>k",                               { desc = "Move to top window" })
vim.keymap.set("n", "<leader>wl", "<c-w>l",                               { desc = "Move to right window" })

vim.keymap.set("n", "<leader>wv", "<c-w>v",                               { desc = "Split vertically" })
vim.keymap.set("n", "<leader>ws", "<c-w>s",                               { desc = "Split horizontally" })
vim.keymap.set("n", "<leader>we", "<c-w>=",                               { desc = "Equal windows" })
vim.keymap.set("n", "<leader>wx", "<cmd>close<cr>",                       { desc = "Close window" })

vim.keymap.set("n", "<leader>sv", "<c-w>v",                               { desc = "Split vertically" })
vim.keymap.set("n", "<leader>sh", "<c-w>s",                               { desc = "Split horizontally" })
vim.keymap.set("n", "<leader>se", "<c-w>=",                               { desc = "Equal splits" })
vim.keymap.set("n", "<leader>sx", "<cmd>close<cr>",                       { desc = "Close split" })

vim.keymap.set("v", "<leader>s", ":'<,'>!sort -f<cr>",                    { desc = "Sort selection" })

vim.keymap.set("n", "<leader>to", "<cmd>tabnew<cr>",                      { desc = "Open new tab" })
vim.keymap.set("n", "<leader>tx", "<cmd>tabclose<cr>",                    { desc = "Close tab" })
vim.keymap.set("n", "<leader>tn", "<cmd>tabnext<cr>",                     { desc = "Next tab" })
vim.keymap.set("n", "<leader>tp", "<cmd>tabprevious<cr>",                 { desc = "Previous tab" })
vim.keymap.set("n", "<leader>tf", "<cmd>tabnew %<cr>",                    { desc = "Current buffer in new tab" })
vim.keymap.set("n", "<leader>ta", "<cmd>lua require('nvim-toggler').toggle()<cr>", { desc = "Toggle alternative" })

vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<cr>",                     { desc = "Neogit" })
vim.keymap.set("n", "<leader>gb", "<cmd>Gitsigns blame_line<cr>",       { desc = "Blame line" })
vim.keymap.set("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<cr>",     { desc = "Preview hunk" })
vim.keymap.set("n", "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>",       { desc = "Reset hunk" })
vim.keymap.set("n", "<leader>gs", "<cmd>Gitsigns stage_hunk<cr>",        { desc = "Stage hunk" })
vim.keymap.set("n", "<leader>gu", "<cmd>Gitsigns undo_stage_hunk<cr>",  { desc = "Undo stage hunk" })

vim.keymap.set("n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>",   { desc = "Code actions" })
vim.keymap.set("n", "<leader>ld", "<cmd>lua vim.lsp.buf.definition()<cr>",   { desc = "Go to definition" })
vim.keymap.set("n", "<leader>lD", "<cmd>lua vim.lsp.buf.declaration()<cr>", { desc = "Go to declaration" })
vim.keymap.set("n", "<leader>li", "<cmd>lua vim.lsp.buf.implementation()<cr>", { desc = "Go to implementation" })
vim.keymap.set("n", "<leader>lr", "<cmd>lua vim.lsp.buf.references()<cr>",   { desc = "Show references" })
vim.keymap.set("n", "<leader>lR", "<cmd>lua vim.lsp.buf.rename()<cr>",      { desc = "Rename symbol" })
vim.keymap.set("n", "<leader>lh", "<cmd>lua vim.lsp.buf.hover()<cr>",      { desc = "Hover documentation" })
vim.keymap.set("n", "<leader>ls", "<cmd>lua vim.lsp.buf.signature_help()<cr>", { desc = "Signature help" })

vim.keymap.set("n", "<leader>dd", "<cmd>lua vim.diagnostic.open_float()<cr>", { desc = "Show line diagnostics" })
vim.keymap.set("n", "<leader>dn", "<cmd>lua vim.diagnostic.goto_next()<cr>",   { desc = "Next diagnostic" })
vim.keymap.set("n", "<leader>dp", "<cmd>lua vim.diagnostic.goto_prev()<cr>",   { desc = "Previous diagnostic" })
vim.keymap.set("n", "<leader>dl", "<cmd>lua vim.diagnostic.setloclist()<cr>",  { desc = "Diagnostics to location list" })
vim.keymap.set("n", "<leader>dq", "<cmd>lua vim.diagnostic.setqflist()<cr>",  { desc = "Diagnostics to quickfix" })
vim.keymap.set("n", "<leader>dr", "<cmd>lua vim.diagnostic.reset()<cr>",       { desc = "Reset diagnostics" })
vim.keymap.set("n", "<leader>de", "<cmd>lua vim.diagnostic.goto_next({severity = vim.diagnostic.severity.ERROR})<cr>", { desc = "Next error" })
vim.keymap.set("n", "<leader>dw", "<cmd>lua vim.diagnostic.goto_next({severity = vim.diagnostic.severity.WARN})<cr>",  { desc = "Next warning" })

vim.keymap.set("n", "<leader>jf", "<cmd>HopWordMW<cr>",  { desc = "Jump to word" })
vim.keymap.set("n", "<leader>jl", "<cmd>HopLineStart<cr>", { desc = "Jump to line" })
vim.keymap.set("n", "<leader>jc", "<cmd>HopChar1<cr>",   { desc = "Jump to character" })

-- vim.keymap.set("n", "<leader><leader>f", "<cmd>lua require('custom.experiments').fold()<cr>", { desc = "Fold experiments" })
vim.keymap.set("n", "<leader><leader>x", "<cmd>lua require('core.functions').save_and_execute()<cr>", { desc = "Save and execute" })

vim.keymap.set("n", "<C-P>", "<cmd>CmdPalette<cr>",      { desc = "Command palette" })

vim.keymap.set("n", "ga", "<Plug>(EasyAlign)",           { desc = "Easy align" })

vim.keymap.set("n", "gPd", "<cmd>lua require('goto-preview').goto_preview_definition()<cr>",   { desc = "Preview definition" })
vim.keymap.set("n", "gPi", "<cmd>lua require('goto-preview').goto_preview_implementation()<cr>", { desc = "Preview implementation" })
vim.keymap.set("n", "gPr", "<cmd>lua require('goto-preview').goto_preview_references()<cr>",  { desc = "Preview references" })
vim.keymap.set("n", "gP",  "<cmd>lua require('goto-preview').close_all_win()<cr>",          { desc = "Close all preview windows" })
