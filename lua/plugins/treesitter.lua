require("globals")

return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    build = ":TSUpdate",
    event = LoadOnBuffer,
    enabled = Is_enabled("treesitter"),
    dependencies = {
      "filNaj/tree-setter",
      "nvim-treesitter/playground",
      "nvim-treesitter/nvim-treesitter-refactor",
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        lazy = true,
      },
    },

    opts = {
      highlight = { enable = true, additional_vim_regex_highlighting = true },
      indent = { enable = true },
      ensure_installed = {
        "vim",
        "regex",
        "css",
        "go",
        "query",
        "graphql",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "markdown",
        "markdown_inline",
        "tsx",
        "typescript",
        "yaml",
        "lua",
        "gitcommit",
      },
      tree_setter = {
        enable = false,
      },
      refactor = {
        smart_rename = {
          enable = true,
          -- Assign keymaps to false to disable them, e.g. `smart_rename = false`.
          keymaps = {
            smart_rename = "gr",
          },
        },
      },
    },

    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}
