vim.opt.fillchars:append({
  eob = "~",
  fold = " ",
  foldopen = "▽",
  foldsep = "│",
  foldclose = "▶",
})

-- changed to number because I want to see the folds
-- there for it saves a little space
vim.opt.signcolumn = "number"

vim.wo.foldnestmax = 3
-- keep all folds open by default
vim.wo.foldlevel = 99
-- show the fold column (you can also rely on the sign column)
vim.wo.foldcolumn = "1"
-- -- always show the sign column so the markers are visible

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldtext = require("configuration.fold-text")
vim.opt.foldminlines = 3

vim.cmd([[highlight clear Folded]])
