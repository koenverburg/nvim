local prefix = "<space>g"

return {
  {
    "lewis6991/gitsigns.nvim",
    lazy = false,
    enabled = true,
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      {
        "]c",
        function()
          if vim.wo.diff then
            return "]c"
          end
          vim.schedule(function()
            require("gitsigns").next_hunk()
          end)
          return "<Ignore>"
        end,
        expr = true,
        desc = "Next git hunk",
      },
      {
        "[c",
        function()
          if vim.wo.diff then
            return "[c"
          end
          vim.schedule(function()
            require("gitsigns").prev_hunk()
          end)
          return "<Ignore>"
        end,
        expr = true,
        desc = "Previous git hunk",
      },
      { prefix .. "hs", "<cmd>Gitsigns stage_hunk<cr>", desc = "Stage hunk", mode = { "n", "v" } },
      { prefix .. "hr", "<cmd>Gitsigns reset_hunk<cr>", desc = "Reset hunk", mode = { "n", "v" } },
      { prefix .. "hS", "<cmd>Gitsigns stage_buffer<cr>", desc = "Stage buffer" },
      { prefix .. "hu", "<cmd>Gitsigns undo_stage_hunk<cr>", desc = "Undo stage hunk" },
      { prefix .. "hR", "<cmd>Gitsigns reset_buffer<cr>", desc = "Reset buffer" },
      { prefix .. "hp", "<cmd>Gitsigns preview_hunk<cr>", desc = "Preview hunk" },
      { prefix .. "hb", "<cmd>Gitsigns blame_line<cr>", desc = "Blame line" },
      { prefix .. "hd", "<cmd>Gitsigns diffthis<cr>", desc = "Diff this" },
      {
        prefix .. "hD",
        function()
          require("gitsigns").diffthis("~")
        end,
        desc = "Diff this ~",
      },
      { prefix .. "tb", "<cmd>Gitsigns toggle_current_line_blame<cr>", desc = "Toggle git blame line" },
      { prefix .. "td", "<cmd>Gitsigns toggle_deleted<cr>", desc = "Toggle git deleted" },
      { "ih", ":<C-U>Gitsigns select_hunk<CR>", desc = "Select git hunk", mode = { "o", "x" } },
    },
    opts = {
      signs = {

        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        -- add = { text = "│" },
        -- change = { text = "│" },
        -- delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
      },
      signcolumn = true,
      numhl = false,
      linehl = false,
      word_diff = false,
      watch_gitdir = {
        follow_files = true,
      },
      attach_to_untracked = true,
      current_line_blame = false,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol",
        delay = 1000,
        ignore_whitespace = false,
      },
      preview_config = {
        border = "rounded",
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
      },
    },
    config = function(_, opts)
      require("gitsigns").setup(opts)
    end,
  },

  -- Neogit: magit-like git interface
  {
    "NeogitOrg/neogit",
    enabled = true,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    cmd = "Neogit",
    keys = {
      { prefix .. "gs", "<cmd>Neogit<cr>", desc = "Neogit status" },
      { prefix .. "gc", "<cmd>Neogit commit<cr>", desc = "Neogit commit" },
      { prefix .. "gp", "<cmd>Neogit pull<cr>", desc = "Neogit pull" },
      { prefix .. "gP", "<cmd>Neogit push<cr>", desc = "Neogit push" },
      { prefix .. "gb", "<cmd>Neogit branch<cr>", desc = "Neogit branch" },
      { prefix .. "gB", "<cmd>Telescope git_branches<cr>", desc = "Git branches" },
    },
    opts = {
      graph_style = "unicode",
      integrations = {
        telescope = true,
        diffview = true,
      },
      sections = {
        untracked = {
          folded = false,
        },
        unstaged = {
          folded = false,
        },
        staged = {
          folded = false,
        },
      },
    },
  },

  -- Diffview: advanced diff viewing
  {
    "sindrets/diffview.nvim",
    enabled = true,
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewFileHistory" },
    keys = {
      { prefix .. "gd", "<cmd>DiffviewOpen<cr>", desc = "Diffview open" },
      { prefix .. "gD", "<cmd>DiffviewClose<cr>", desc = "Diffview close" },
      { prefix .. "gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File history" },
      { prefix .. "gH", "<cmd>DiffviewFileHistory<cr>", desc = "Branch history" },
    },
    opts = {
      enhanced_diff_hl = true,
      view = {
        default = {
          layout = "diff2_horizontal",
        },
        merge_tool = {
          layout = "diff3_mixed",
        },
        file_history = {
          layout = "diff2_horizontal",
        },
      },
      file_panel = {
        listing_style = "tree",
        tree_options = {
          flatten_dirs = true,
          folder_statuses = "only_folded",
        },
        win_config = {
          position = "left",
          width = 35,
        },
      },
      file_history_panel = {
        log_options = {
          git = {
            single_file = {
              diff_merges = "combined",
            },
            multi_file = {
              diff_merges = "first-parent",
            },
          },
        },
        win_config = {
          position = "bottom",
          height = 16,
        },
      },
      hooks = {
        diff_buf_read = function()
          vim.opt_local.wrap = false
          vim.opt_local.list = false
        end,
      },
    },
  },
}
