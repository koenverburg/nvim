return {
  "xiantang/darcula-dark.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  lazy = false,
  enabled = false,
  config = function()
    -- TODO update hairline
    -- TODO make function keywords bold
    require("darcula").setup({
      opt = {
        integrations = {
          snacks = false,
          lualine = false,
          nvim_cmp = true,
          dap_nvim = true,
          telescope = false,
          lsp_semantics_token = true,
        },
      },
    })
  end,
}
