require("globals")

return {
  "hrsh7th/nvim-cmp",
  event = LoadOnBuffer,
  enabled = false, -- Is_enabled("lsp"),
  dependencies = {
    "mason.nvim",
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-nvim-lsp",
    "onsails/lspkind-nvim",
    "saadparwaiz1/cmp_luasnip",
    "L3MON4D3/LuaSnip",
  },
  config = function()
    require("plugin-configs.cmp")
  end,
}
