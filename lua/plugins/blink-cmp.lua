require("globals")

return {
  {
    "saghen/blink.cmp",
    enabled = Is_enabled("blink-cmp"),
    event = "InsertEnter",
    dependencies = {
      "avante.nvim",
      "saghen/blink.compat",
      -- 'rafamadriz/friendly-snippets'
    },

    version = "1.*",
    -- build = 'cargo build --release',

    config = function()
      require("plugin-configs.blink-cmp")
    end,

    opts_extend = { "sources.default" },
  },
}
