-- TODO setup formatting for my personal settings and the one from adidas.

return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  enabled = true,
  keys = {
    {
      "<leader>lf",
      "<cmd>lua require('conform').format()<cr>",
      desc = "Formatter",
    },
  },
  opts = {
    formatters_by_ft = {
      go = { "goimports", "gofumpt" },
      lua = { "stylua" },
      javascript = { "eslint_d", "eslint" },
      typescript = { "eslint_d", "eslint" },
      reactjavascript = { "eslint_d", "eslint" },
      reacttypescript = { "eslint_d", "eslint" },
      jsx = { "eslint_d", "eslint" },
      tsx = { "eslint_d", "eslint" },
      html = { "prettier" },
      css = { "prettier" },
      scss = { "prettier" },
      json = { "prettier" },
      jsonc = { "prettier" },
      markdown = { "prettier" },
      ["markdown.mdx"] = { "prettier" },
      yaml = { "prettier" },
      yml = { "prettier" },
      xml = { "prettier" },
      svg = { "prettier" },
      ["*"] = { "codespell" },
    },
    format_on_save = {
      timeout_ms = 2000,
      lsp_fallback = false,
    },
  },
}
