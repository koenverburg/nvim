local opt = vim.opt

opt.number = true
opt.mouse = "a"

opt.showmode = false

opt.breakindent = true

opt.undofile = true

opt.ignorecase = true
opt.smartcase = true

opt.signcolumn = "auto"
opt.list = false

opt.updatetime = 250
opt.timeoutlen = 300

opt.splitright = true
opt.splitbelow = true

opt.inccommand = "split"

opt.cursorline = true
opt.scrolloff = 10

opt.confirm = true

opt.hidden = true
opt.ruler = true
opt.expandtab = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.autoindent = true
opt.showtabline = 1
opt.laststatus = 3
opt.shortmess = vim.o.shortmess .. "cFI"
opt.cmdheight = 1
opt.completeopt = "menu,menuone,noselect,noinsert"
opt.wildignore:append({
  ".javac",
  "node_modules",
  "*.pyc",
  "~/.bun/cache",
  ".aux",
  ".out",
  ".toc",
  ".o",
  ".obj",
  ".dll",
  ".exe",
  ".so",
  ".a",
  ".lib",
  ".pyo",
  ".pyd",
  ".swp",
  ".swo",
  ".class",
  ".DS_Store",
  ".git",
  ".hg",
  ".orig",
})

opt.suffixesadd:append({ ".java", ".rs" })
opt.listchars = "tab:» ,trail:·,extends:>,precedes:<,space:·"
vim.wo.fillchars = "eob:~,fold: " -- fillchars of windows
opt.sessionoptions = "blank,buffers,curdir,folds,globals,help,localoptions,tabpages,terminal,winpos,winsize"
opt.winborder = "rounded"
opt.diffopt = "internal,filler,closeoff,inline:simple,linematch:40"
opt.wildmode = "list:longest,list:full"
opt.splitkeep = "screen"

opt.clipboard:append("unnamed")
opt.clipboard:append("unnamedplus")

-- File‑type detection -------------------------------------------------------
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
    [".env"] = "dosini",
    [".eslintrc"] = "json",
    [".prettierrc"] = "json",
    [".stylelintrc"] = "json",
  },
  pattern = {
    [".env.*"] = "dosini",
    [".*config/git/config"] = "gitconfig",
  },
})

-- Folding ------------------------------------------------------------------
opt.foldenable = false
opt.foldmethod = "manual"
opt.foldminlines = 2

-- LSP & diagnostics --------------------------------------------------------
vim.lsp.enable({
  "tsgo",
  "lua_ls",
  "stylua",
})

vim.diagnostic.config({
  virtual_text = false,
  signs = {
    text = {
      [vim.diagnostic.severity.INFO] = "",
      [vim.diagnostic.severity.HINT] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.ERROR] = "",
    },
  },
  underline = true,
  severity_sort = true,
  update_in_insert = false,
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "always",
  },
})

-- Misc ---------------------------------------------------------------------
opt.cursorline = true
vim.api.nvim_set_hl(0, "CursorLine", { underline = true })

vim.cmd("language en_US.utf-8")
