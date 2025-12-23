return {
  {
    -- "koenverburg/static.nvim",
    dir = "~/code/github/static.nvim",
    enabled = false, -- Is_enabled("personal/static"),
    lazy = false,
    keys = {
      { "<leader>fi", "<cmd>lua require('static.treesitter').fold_imports()<cr>", desc = "Static - fold imports" },
      { "<leader>fr", "<cmd>lua require('static.treesitter').region()<cr>", desc = "Static - fold regions" },
    },
    config = function()
      require("static").setup()
    end,
  },
  {
    dir = "~/code/github/reverse-engineer.nvim",
    ft = { "javascript", "typescript", "c", "cpp", "go", "rust", "python" },

    -- (optional) load on BufReadPost or when you explicitly call it
    -- event = "BufReadPost",

    dependencies = {
      -- TreeSitter parsers are installed via nvim-treesitter
      "nvim-treesitter/nvim-treesitter",
    },

    config = function()
      -- expose defaults or let user override
      require("reverse-engineer").setup({
        score_threshold = 1, -- show identifiers with 3+ characters
        fold_minified = true, -- automatically fold minified blocks
        quickfix_group = "Important",
        highlight_group = "MinifyImportant",
      })
    end,

    keys = {
      { "<leader>Rd", ":MinifyDetect<CR>", desc = "Detect important symbols" },
      { "<leader>Rrn", ":MinifyRename<CR>", desc = "Rename identifier under cursor" },
    },

    -- optional: keep the plugin in cache but never load it on start
    lazy = true,
  },
}
