return {
  {
    "saghen/blink.cmp",
    lazy = true,
    enabled = true,
    event = "InsertEnter",
    dependencies = {
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
      -- "saghen/blink.compat",
      -- "Kaiser-Yang/blink-cmp-avante",
    },

    version = "1.*",
    -- build = 'cargo build --release',

    config = function()
      require("luasnip.loaders.from_vscode").load()
      require("luasnip.loaders.from_lua").load({
        paths = vim.fn.stdpath("config") .. "/snippets",
      })

      require("2_configs.config-blink-cmp")

      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      })
    end,

    opts_extend = { "sources.default" },
  },
}
