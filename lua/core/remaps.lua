local funcs = require("core.functions")
local normal = funcs.normal
local visual = funcs.visual
local insert = funcs.insert

--------------------------------------------------------------------------------
-- Vim bindings
--------------------------------------------------------------------------------
normal("q", "NOP") -- turn of recording of macros
normal("G", "Gzz")

-- Swap : and ; to make colon commands easer to type
normal(";", ":")
normal(":", ";")

-- Quick folding
normal("<space>f", "za<cr>")

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
normal("<space>fr", ":%s/")

-- normal("<C-j>", "<C-W><C-J>")
-- normal("<C-k>", "<C-W><C-K>")
-- normal("<C-l>", "<C-W><C-L>")
-- normal("<C-h>", "<C-W><C-H>")

-- Show listchars
normal("<space>sl", "<cmd>set invlist<cr>")

--------------------------------------------------------------------------------
-- Custom bindings
--------------------------------------------------------------------------------

-- Toggle between test files and implementation
normal("<space>ta", "<cmd>lua require('custom.experiments').edit()<cr>")
normal("<leader><leader>f", "<cmd>lua require('custom.experiments').fold()<cr>")

-- Toggle Terms
normal("<leader><leader>ot", "<cmd>lua require('custom.experiments').open_term()<cr>")
normal("<leader><leader>on", "<cmd>lua require('custom.experiments').open_node_repl()<cr>")

-- Command Palette
normal("<c-P>", "<cmd>CmdPalette<cr>")

-- Save and execute
normal("<leader><leader>x", "<cmd>lua require'core.functions'.save_and_execute()<cr>")
