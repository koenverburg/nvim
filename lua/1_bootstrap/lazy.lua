require("lazy").setup({
  spec = {
    { import = "plugins" },
    { import = "plugins/completion" },
    { import = "plugins/lsp" },
    { import = "plugins/navigation" },
    { import = "plugins/themes" },
    { import = "plugins/ui" },
    { import = "plugins/dap" },
    { import = "plugins/personal" },
    { import = "plugins/simplicity" },
  },

  rocks = {
    enabled = false,
  },

  defaults = {
    lazy = true,
    version = false,
  },

  checker = { enabled = true, notify = false },

  performance = {
    cache = {
      enabled = true,
    },
    rtp = {
      disabled_plugins = {
        "gzip",
        "tar",
        "tarPlugin",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tohtml",
        "tutor",
        "zip",
        "zipPlugin",
        "netrw",
        "netrwPlugin",
        "netrwSettings",
        "netrwFileHandlers",
      },
    },
  },
})
