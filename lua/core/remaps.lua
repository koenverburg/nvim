local keymaps = require("core.keymaps")

keymaps.setup()

local map = vim.keymap.set

for i = 1, 8 do
  map({ "n", "t" }, "<Leader>" .. i, "<Cmd>tabnext " .. i .. "<CR>")
end

vim.keymap.set("n", "<leader>sd", function()
  vim.diagnostic.open_float({ border = "rounded" })
end, { desc = "Show line diagnostics", noremap = true, silent = true })

vim.keymap.set("n", "<leader>dp", vim.diagnostic.goto_prev, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>dn", vim.diagnostic.goto_next, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>dd", vim.diagnostic.open_float, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>ds", vim.diagnostic.setloclist, { noremap = true, silent = true })

-- Terminal mode navigation (needs to be set after terminal plugins load)
vim.keymap.set("t", "<C-h>", "<C-\\><C-N><C-w>h", { desc = "Move to left window from terminal" })
vim.keymap.set("t", "<C-j>", "<C-\\><C-N><C-w>j", { desc = "Move to bottom window from terminal" })
vim.keymap.set("t", "<C-k>", "<C-\\><C-N><C-w>k", { desc = "Move to top window from terminal" })
vim.keymap.set("t", "<C-l>", "<C-\\><C-N><C-w>l", { desc = "Move to right window from terminal" })

-- Visual mode specific mappings that might conflict if set too early
vim.keymap.set("v", "H", "^", { desc = "Go to first non-blank character" })
vim.keymap.set("v", "L", "g_", { desc = "Go to last non-blank character" })
vim.keymap.set("v", "p", "\"_dP", { desc = "Paste without yanking" })

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
