require("lazy").setup({
  spec = {
    { import = "plugins" },
    -- { import = "plugins/navigation" },
    -- { import = "plugins/themes" },
    -- { import = "plugins/ui" },
    -- { import = "plugins/dap" },
    -- { import = "plugins/personal" },
    -- { import = "plugins/simplicity" },
  },

  rocks = {
    enabled = false,
  },

  defaults = {
    lazy = true,
    version = false,
  },

  checker = { enabled = true, notify = false },

  pkg = {
      enabled = true,
      cache = vim.fn.stdpath("state") .. "/lazy/pkg-cache.lua",
      sources = {
          "lazy",
          "packspec"
      }
  },

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
        "editorconfig",
        "rplugin"
      },
    },
  },
})
