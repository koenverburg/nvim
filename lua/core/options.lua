local config = require('core.config')

vim.g.mapleader = ","

local opt = vim.opt
-- local cache_dir = vim.env.HOME .. '/.cache/nvim/'

-- opt.background = "dark"
opt.autoindent = true
opt.backspace = "indent,eol,start"
opt.clipboard:append("unnamed")
opt.clipboard:append("unnamedplus")
opt.cmdheight = 1
opt.completeopt:append('noselect') -- = "menu,menuone,noselect,noinsert"
opt.expandtab = true
opt.ruler = true
opt.shortmess = vim.o.shortmess .. "c" .. "F" .. "I"
opt.signcolumn = "number"
opt.tabstop = 2
opt.shiftwidth = 2
opt.showtabline = 2
opt.softtabstop = 2
opt.updatetime = 50
opt.guicursor = ""
opt.number = true
opt.hidden = true
opt.undofile = true
-- opt.colorcolumn = "81"
opt.laststatus = 3
opt.incsearch = true
opt.termguicolors = true
opt.listchars = "tab:🡢\\ ,trail:·,extends:>,precedes:<,space:·"

-- Searching
opt.smartcase = true
opt.ignorecase = true
opt.inccommand = "split"
opt.splitkeep = "screen"

vim.o.showtabline = 1
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
-- vim.o.winborder = 'rounded'
-- opt.switchbuf = 'uselast'
-- opt.undordir = cache_dir .. "undodir/"
-- opt.noswapfile = true

vim.filetype.add({
  extension = {
    snap = "json",
    png = "image",
    jpg = "image",
    jpeg = "image",
    gif = "image",
    es6 = "javascript",
    mts = "typescript",
    cts = "typescript",
  },
  filename = {
    [".eslintrc"] = "json",
    [".prettierrc"] = "json",
    [".babelrc"] = "json",
    [".stylelintrc"] = "json",
  },
  pattern = {
    [".*config/git/config"] = "gitconfig",
    [".env"] = "dosini",
    [".env.*"] = "dosini",
  },
})

-- vim.opt.foldenable = false
-- vim.opt.foldmethod = "manual"
-- vim.cmd [[ set foldlevel=0 ]]
-- vim.cmd [[ set foldmethod=manual ]]

vim.cmd("language en_US.utf-8")
vim.cmd([[ highlight clear SignColumn ]])

-- vim.cmd [[ set nowrap ]]
-- vim.cmd [[ set noshowmode ]]
-- vim.cmd [[ set shortmess-=S ]]

opt.cursorline = true
vim.api.nvim_set_hl(0, 'CursorLine', {
  underline = true,
  -- fg = config.colors.yellow,
  -- bg = config.colors.gray,
})

-- vim.cmd([[
--   highlight CursorLine guibg=#1e1e2e guifg=NONE
-- ]])
