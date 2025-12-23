return {
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    lazy = false,
    opts = {},
    config = function()
      require("refactoring").setup({
        prompt_func_return_type = {
          go = false,
          java = false,
          cpp = false,
          c = false,
          h = false,
          hpp = false,
          cxx = false,
        },
        prompt_func_param_type = {
          go = false,
          java = false,
          cpp = false,
          c = false,
          h = false,
          hpp = false,
          cxx = false,
        },
        printf_statements = {
          -- cpp = {
          --     'std::cout << "%s" << std::endl;'
          -- }
        },
        print_var_statements = {},
        show_success_message = false,
      })
    end,
    keys = {
      { "<leader>re", ":Refactor extract", desc = "Extract", mode = "x" },
      { "<leader>rf", ":Refactor extract_to_file", desc = "Extract to file", mode = "x" },
      { "<leader>rv", ":Refactor extract_var", desc = "Extract to file", mode = "x" },
      { "<leader>ri", ":Refactor inline_var", desc = "inline var", mode = { "n", "x" } },
      { "<leader>rI", ":Refactor inline_func", desc = "inline func" },
      { "<leader>rb", ":Refactor extract_block", desc = "Extract block" },
      { "<leader>rbf", ":Refactor extract_block_to_file", desc = "Extract block to file" },
    },
  },
  {
    "jdrupal-dev/code-refactor.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    keys = {
      { "<leader>rc", "<cmd>CodeActions all<CR>", desc = "code-refactor.nvim" },
    },
    config = function()
      require("code-refactor").setup({
        -- Configuration here, or leave empty to use defaults.
      })
    end,
  },
}
