local opts = {
  views = {
    explorer = {
      git_status = true,
      confirm_simple = true,
      default_explorer = false,
      win = {
        buf_opts = {
          width = 40,
        },
        win_opts = {
          width = 40,
          number = false,
          cursorline = false,
          relativenumber = false,
        },
      },
    },
  },
}

return {
  "A7Lavinraj/fyler.nvim",
  enabled = true,
  branch = "stable",
  dependencies = { "nvim-mini/mini.icons" },
  opts = opts,
  keys = {
    {
      "<leader>fb",
      function()
        require("fyler").toggle(vim.tbl_deep_extend("force", opts, {
          kind = "float",
        }))
      end,
      { desc = "Explorer (left) " },
    },
    {
      "<c-b>",
      function()
        require("fyler").toggle(vim.tbl_deep_extend("force", opts, {
          kind = "split_left_most",
        }))
      end,
      { desc = "Explorer (left) " },
    },
  },
}
