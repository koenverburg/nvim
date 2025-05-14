return {
  "williamboman/mason.nvim",
  event = LoadOnBuffer,
  cmd = "Mason",
  lazy = false,
  enabled = Is_enabled("lsp"),
  keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
  opts = {
    ensure_installed = {
      "stylua",
      "shellcheck",
      "gopls",
      "cssls",
      "ts_ls",
      "dockerls",
      "tailwindcss",
      "yamlls",
      "vtsls",
      "oxlint",
      "biome",
      "eslint_d",
      "rust_analyzer",
      "lua-language-server",
    },
  },
  config = function(_, opts)
    require("mason").setup(opts)
  end,
}
