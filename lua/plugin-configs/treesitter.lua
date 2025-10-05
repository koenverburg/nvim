require("globals")

require("nvim-treesitter.configs").setup({
  highlight = { enable = true, additional_vim_regex_highlighting = false },
  indent = { enable = true },
  ensure_installed = {
    "ini", "vim", "vimdoc", "regex", "css", "go", "query", "html",
    "javascript", "jsdoc", "json", "markdown", "markdown_inline",
    "typescript", "yaml", "lua", "gitcommit", "rust",
  },
  refactor = {
    highlight_definitions = { enable = true, clear_on_cursor_move = true },
    highlight_current_scope = { enable = false, clear_on_cursor_move = true },
    smart_rename = { enable = false, keymaps = { smart_rename = "gr" } },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner", 
        ["ac"] = "@class.outer",
        ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
        ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
      },
      selection_modes = {
        ["@parameter.outer"] = "v",
        ["@function.outer"] = "V", 
        ["@class.outer"] = "<c-v>",
      },
      include_surrounding_whitespace = true,
    },
  },
})
