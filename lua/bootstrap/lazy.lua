require("lazy").setup({
  spec = {
    { import = "plugins" },
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

  checker = { enabled = true },

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
