return {
  {
    "zeioth/garbage-day.nvim",
    dependencies = "neovim/nvim-lspconfig",
    enabled = true,
    event = "VeryLazy",
    opts = {
      aggressive_mode = false,
      grace_period = 60 * 7,
      wakeup_delay = 0,
      -- your options here
    },
  },
}
-- return {
--   {
--     "williamboman/mason.nvim",
--     event = LoadOnBuffer,
--     cmd = "Mason",
--     lazy = false,
--     enabled = false,
--     keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
--     opts = {
--       ensure_installed = {
--         "stylua",
--         "shellcheck",
--         "gopls",
--         "cssls",
--         "ts_ls",
--         "dockerls",
--         "tailwindcss",
--         "yamlls",
--         "rust_analyzer",
--         "lua-language-server",
--       },
--     },
--     config = function(_, opts)
--       require("mason").setup(opts)
--     end,
--   },
-- }
