return {
  {
    "saghen/blink.cmp",
    enabled = true,
    event = "InsertEnter",
    dependencies = {
      -- "saghen/blink.compat",
      "Kaiser-Yang/blink-cmp-avante",
      -- 'rafamadriz/friendly-snippets'
    },

    version = "1.*",
    -- build = 'cargo build --release',

    config = function()
      require("2_plugin-configs.blink-cmp")
      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      })
    end,

    opts_extend = { "sources.default" },
  },
}
