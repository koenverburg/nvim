return {
  {
    "williamboman/mason.nvim",
    event = LoadOnBuffer,
    cmd = "Mason",
    lazy = true,
    enabled = true,
    -- keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    dependencies = {
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function(_, opts)
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })
      local mason_tool_installer = require("mason-tool-installer")

      mason_tool_installer.setup({
        start_delay = 2000,
        run_on_start = true,
        ensure_installed = {
          "tsgo",
          "shellcheck",
          "prettier",
          "stylua",
          "gopls",
          "cssls",
          "ts_ls",
          "js-debug-adapter",
          "vtsls",
          "oxlint",
          "biome",
          "eslint",
          "eslint_d",
          "rust_analyzer",
          "lua-language-server",
        },
      })
    end,
  },
}
