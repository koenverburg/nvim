local funcs = require("core.functions")
local normal = funcs.normal
local visual = funcs.visual
local insert = funcs.insert

--------------------------------------------------------------------------------
-- Vim bindings
--------------------------------------------------------------------------------
normal("q", "NOP", "") -- turn of recording of macros
normal("G", "Gzz", "")

-- Swap : and ; to make colon commands easer to type
normal(";", ":", "")
normal(":", ";", "")

-- Quick folding
normal("<space>f", "normal! za<cr>")

-- Rapid movement
normal("<s-a>", ":edit %:h<cr>")

-- Move whole lines, kudos @theprimeagen
visual("J", ":m '>+1<CR>gv=gv")
visual("K", ":m '<-2<CR>gv=gv")

-- Copy from cursor position to end of the line
normal("Y", "y$")

-- Concat lines below on current line
normal("J", "mzJ`z")

-- Undo until , .
insert(",", ",<c-g>u")
insert(".", ".<c-g>u")

-- This is so I can quickly quite out of vim without having to close all the buffers
normal("<leader>q", "<cmd>lua require('core.functions').quite()<cr>")

-- Better jk
-- normal("j", "<Plug>(accelerated_jk_gj)")
-- normal("k", "<Plug>(accelerated_jk_gk)")

-- Faster moving from beginning to end of a line
normal("H", "^")
normal("L", "g_")

visual("H", "^")
visual("L", "g_")

-- Jumping from the beginning of a []{}() to the end
normal("<Tab>", "%")

-- Splits
normal("-", ":sp<cr>|<c-w>j")
normal("|", ":vsp<cr>|<c-w>l")
normal("<space>-", ":sp<cr>|<c-w>j|:Telescope git_files<cr>")
normal("<space>|", ":vsp<cr>|<c-w>l|:Telescope git_files<cr>")

-- These mappings control the size of splits (height/width)
normal("<M-,>", "<c-w>5<")
normal("<M-.>", "<c-w>5>")
normal("<M-t>", "<C-W>+")
normal("<M-s>", "<C-W>-")

-- Keep search matches in the middle of the window
normal("n", "nzzzv")
normal("N", "Nzzzv")

-- Quickly return to normal mode
insert("jk", "<esc>")
insert("jj", "<esc>")
insert("kk", "<esc>")

-- keep text selected after indentation
visual("<", "<gv")
visual(">", ">gv")

-- quickly cancel search highlighting
normal("<leader><space>", ":nohl<cr>")

-- Faster saving
-- normal('<leader>w', ':w<cr>')
-- insert('<leader>w', ':w<cr>')

-- Creating a new tab
normal("<leader>t", ":tabnew<cr>|:Telescope git_files<cr>")

-- Tab movement
normal("<S-Tab>", ":tabnext<cr>")

normal("<space>", "za")

-- Credo, sort aliases in alphabetical order
visual("<leader>s", ":'<,'>!sort -f<cr>")

-- open folds faster, za toggles folds that are created
normal("of", "za")

-- Find and Replace
normal("<space>fr", ":%s/<<C-r><C-w>>//g<Left><Left>")

normal("<C-j>", "<C-W><C-J>")
normal("<C-k>", "<C-W><C-K>")
normal("<C-l>", "<C-W><C-L>")
normal("<C-h>", "<C-W><C-H>")

-- window management
normal("<leader>sv", "<C-w>v", "Split window vertically") -- split window vertically
normal("<leader>sh", "<C-w>s", "Split window horizontally") -- split window horizontally
normal("<leader>se", "<C-w>=", "Make splits equal size") -- make split windows equal width & height
normal("<leader>sx", "<cmd>close<CR>", "Close current split") -- close current split window

normal("<leader>h", "<Cmd>wincmd h<CR>", "Move cursor to left window")
normal("<leader>j", "<Cmd>wincmd j<CR>", "Move cursor to bottomw window")
normal("<leader>k", "<Cmd>wincmd k<CR>", "Move cursor to top window")
normal("<leader>l", "<Cmd>wincmd l<CR>", "Move cursor to right window")

normal("<leader>to", "<cmd>tabnew<CR>", "Open new tab") -- open new tab
normal("<leader>tx", "<cmd>tabclose<CR>", "Close current tab") -- close current tab
normal("<leader>tn", "<cmd>tabn<CR>", "Go to next tab") --  go to next tab
normal("<leader>tp", "<cmd>tabp<CR>", "Go to previous tab") --  go to previous tab
normal("<leader>tf", "<cmd>tabnew %<CR>", "Open current buffer in new tab") --  move current buffer to new tab

-- Show listchars
normal("<space>sl", "<cmd>set invlist<cr>")

-- normal("<C-k>", "<cmd>cnext<CR>zz")
-- normal("<C-j>", "<cmd>cprev<CR>zz")

--------------------------------------------------------------------------------
-- Custom bindings
--------------------------------------------------------------------------------

-- Toggle between test files and implementation
normal("<space>ta", "<cmd>lua require('custom.experiments').edit()<cr>")
normal("<leader><leader>f", "<cmd>lua require('custom.experiments').fold()<cr>")

-- Command Palette
normal("<c-P>", "<cmd>CmdPalette<cr>")

-- Save and execute
normal("<leader><leader>x", "<cmd>lua require'core.functions'.save_and_execute()<cr>")

--------------------------------------------------------------------------------
-- LSP
--------------------------------------------------------------------------------
normal("<leader>sd", "<cmd>lua vim.diagnostic.open_float({ border = 'rounded' })<cr>")
normal("gd", "<cmd>lua vim.lsp.buf.definition()<cr>")
normal("gD", "<cmd>lua vim.lsp.buf.declaration()<cr>")

normal('<leader>i', function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = vim.api.nvim_get_current_buf() }))
end, "Toggle inlay hints" )

-- "<cmd>lua vim.lsp.inlay_hint.enable()<cr>"
