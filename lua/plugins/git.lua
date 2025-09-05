require("globals")

return {
  {
    "lewis6991/gitsigns.nvim",
    enabled = Is_enabled("git"),
    event = { "BufReadPre", "BufNewFile" },
    lazy = false,
    opts = {
      signs = {
        add = { hl = "GitSignsAdd", text = "│", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
        change = { hl = "GitSignsChange", text = "│", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
        delete = { hl = "GitSignsDelete", text = "_", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
        topdelete = { hl = "GitSignsDelete", text = "‾", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
        changedelete = { hl = "GitSignsChange", text = "~", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
        untracked = { hl = "GitSignsAdd", text = "│", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
      },
      numhl = true,
      linehl = false,
    },
    config = function(_, opts)
      require("gitsigns").setup(opts)
    end,
  },
  -- {
  --   "TimUntersberger/neogit",
  --   enabled = Is_enabled("git"),
  --   dependencies = { "nvim-lua/plenary.nvim" },
  --   keys = {
  --     { "<leader>gg", "<cmd>Neogit<cr>" },
  --   },
  --   config = function()
  --     require("neogit").setup({
  --       integrations = {
  --         diffview = true,
  --       },
  --     })
  --   end,
  -- },
  {
    "sindrets/diffview.nvim",
    enabled = Is_enabled("git"), -- probably need this for ai
  },
  -- {
  --   "kdheepak/lazygit.nvim",
  --   cmd = {
  --     "LazyGit",
  --     "LazyGitConfig",
  --     "LazyGitCurrentFile",
  --     "LazyGitFilter",
  --     "LazyGitFilterCurrentFile",
  --   },
  --   -- optional for floating window border decoration
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --   },
  --   -- setting the keybinding for LazyGit with 'keys' is recommended in
  --   -- order to load the plugin when the command is run for the first time
  --   keys = {
  --     { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
  --   },
  -- },
}
