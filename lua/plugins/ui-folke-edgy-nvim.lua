-- local signs = require("core.config").diagnosticSigns

-- Mobile is laptop screen only
local MOBILE_MODE = false
-- Home 32" monitor
local HOME_MODE = true
-- Office 34" wide screen
local OFFICE_MODE = false

local section_left = {}
local section_top = {}
local section_bottom = {}
local section_right = {}

return {
  {
    "folke/edgy.nvim",
    lazy = false,
    -- event = "VeryLazy",
    enabled = true,
    opts = {
      exit_when_last = true,
      top = {
        {
          ft = "help",
          filter = function(buf)
            return vim.api.nvim_get_option_value("buftype", { buf = buf }) == "help"
          end,
          title = "Help",
          size = { height = 0.3 },
        },
      },
      left = {
        {
          ft = "trouble",
          pinned = true,
          title = "Type",
          filter = function(_buf, win)
            return vim.w[win].trouble and vim.w[win].trouble.mode == "lsp_type_definitions"
          end,
          open = "Trouble lsp_type_definitions toggle focus=false",
          size = { height = 0.2 },
        },
        {
          ft = "trouble",
          pinned = true,
          title = "Definitions",
          filter = function(_buf, win)
            return vim.w[win].trouble and vim.w[win].trouble.mode == "lsp_definitions"
          end,
          open = "Trouble lsp_definitions toggle focus=false",
          size = { height = 0.4 },
        },
        {
          ft = "trouble",
          pinned = true,
          title = "References",
          filter = function(_buf, win)
            return vim.w[win].trouble and vim.w[win].trouble.mode == "lsp_references"
          end,
          open = "Trouble lsp_references toggle focus=false",
          size = { height = 0.4 },
        },
      },
      bottom = {
        { ft = "qf", title = "QuickFix", size = { height = 0.25 } },
      },
      right = {
        {
          ft = "trouble",
          pinned = true,
          title = "Symbols",
          filter = function(_buf, win)
            return vim.w[win].trouble and vim.w[win].trouble.mode == "symbols" and vim.w[win].trouble.type == "split"
          end,
          open = "Trouble symbols toggle focus=false",
          size = { height = 0.8 },
        },
        {
          ft = "trouble",
          pinned = true,
          title = "Diagnostics",
          filter = function(_buf, win)
            return vim.w[win].trouble.mode == "diagnostics"
          end,
          open = "Trouble diagnostics toggle focus=false filter.buf=0", --" filter.severity=vim.diagnostic.severity.ERROR",
          size = { height = 0.2 },
        },
      },
      keys = {
        -- increase width
        ["<m-Right>"] = function(win)
          win:resize("width", 2)
        end,
        -- decrease width
        ["<m-Left>"] = function(win)
          win:resize("width", -2)
        end,
        -- increase height
        ["<m-Up>"] = function(win)
          win:resize("height", 2)
        end,
        -- decrease height
        ["<m-Down>"] = function(win)
          win:resize("height", -2)
        end,
      },
      options = {
        left = { size = 45 },
        right = { size = 45 },
      },
      animate = {
        enabled = false, -- disable animations for better performance
      },
    },
  },

  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    enabled = true,
    opts = {
      focus = false,
      auto_preview = false,

      -- auto_open = true,
      -- warn_no_results = false, -- show a warning when there are no results
      -- open_no_results = true, -- open the trouble window when there are no results
      -- throttle = {
      --   -- refresh = 20, -- fetches new data when needed
      --   update = 300, -- updates the window
      --   -- render = 10, -- renders the window
      --   follow = 300, -- follows the current item
      --   -- preview = { ms = 100, debounce = true }, -- shows the preview for the current item
      -- },
      modes = {
        diagnostics = {
          groups = {},

          sort = { "severity" }, -- , "filename", "pos", "message" },
          format = "{item.source} {severity_icon} {message:md}",

          -- auto_open = true,
          -- auto_close = true,
          warn_no_results = false, -- show a warning when there are no results
          open_no_results = true, -- open the trouble window when there are no results

          indent_guides = false,
        },

        -- The LSP base mode for:
        -- * lsp_definitions, lsp_references, lsp_implementations
        -- * lsp_type_definitions, lsp_declarations, lsp_command
        lsp_base = {
          -- TODO clean up the group and title, desc stuff to make it more minial
          pinned = true,
          open_no_results = true,

          params = {
            -- don't include the current location in the results
            include_current = false,
          },
        },

        lsp_references = {
          groups = {},
          desc = {},
          -- title = "",
          -- some modes are configurable, see the source code for more details
          params = {
            include_declaration = true,
          },
        },

        symbols = {
          -- auto_open = true,
          -- auto_close = true,

          groups = {},
          format = "{kind_icon} {symbol.name}",

          -- format = "{kind_icon} {symbol.name} {text:Comment} {pos}",
          filter = {
            -- remove Package since luals uses it for control flow structures
            ["not"] = { ft = "lua", kind = "Package" },
            any = {
              -- all symbol kinds for help / markdown files
              ft = { "help", "markdown" },
              -- default set of symbol kinds
              kind = {
                "Class",
                "Constructor",
                "Enum",
                -- "Field",
                "Function",
                "Interface",
                "Method",
                "Module",
                "Namespace",
                "Package",
                -- "Property",
                "Struct",
                "Trait",
                -- "Variable",
              },
            },
          },
        },
      },
      win_config = { border = "single" },
      icons = {
        indent = {
          last = "╰╴",
        },
      },
    },

    cmd = "Trouble",

    keys = {
      -- { "<leader>ed", "<cmd>Trouble diagnostics toggle focus=false<cr>", desc = "Diagnostics (Trouble)" },
      { "<leader>ed", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
      { "<leader>es", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols (Trouble)" },
      {
        "<leader>er",
        "<cmd>Trouble lsp_references toggle focus=false<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      -- {
      --   "<leader>el",
      --   "<cmd>Trouble lsp toggle focus=false<cr>",
      --   desc = "LSP Definitions / references / ... (Trouble)",
      -- },
      -- { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
      -- { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
    },

    config = function(_, opts)
      require("trouble").setup(opts)
    end,
  },
  -- {
  --   "folke/todo-comments.nvim",
  --   enabled = true,
  --   dependencies = { "nvim-lua/plenary.nvim" },
  --   opts = {
  --     signs = true, -- show icons in the signs column
  --     sign_priority = 8, -- sign priority
  --     -- keywords recognized as todo comments
  --     keywords = {
  --       FIX = {
  --         icon = " ", -- icon used for the sign, and in search results
  --         color = "error", -- can be a hex color, or a named color
  --         alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
  --       },
  --       TODO = { icon = " ", color = "info" },
  --       HACK = { icon = " ", color = "warning" },
  --       WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
  --       PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
  --       NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
  --       TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
  --     },
  --     gui_style = {
  --       fg = "NONE", -- The gui style to use for the fg highlight group.
  --       bg = "BOLD", -- The gui style to use for the bg highlight group.
  --     },
  --     merge_keywords = true, -- when true, custom keywords will be merged with the defaults
  --     -- highlighting of the line containing the todo comment
  --     highlight = {
  --       multiline = true, -- enable multine todo comments
  --       multiline_pattern = "^.", -- lua pattern to match the next multiline from the start of the matched keyword
  --       multiline_context = 10, -- extra lines that will be re-evaluated when changing a line
  --       before = "", -- "fg" or "bg" or empty
  --       keyword = "wide", -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty
  --       after = "fg", -- "fg" or "bg" or empty
  --       pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlighting (vim regex)
  --       comments_only = true, -- uses treesitter to match keywords in comments only
  --       max_line_len = 400, -- ignore lines longer than this
  --       exclude = {}, -- list of file types to exclude highlighting
  --     },
  --     -- list of named colors where we try to extract the guifg from the
  --     -- list of highlight groups or use the hex color if hl not found as a fallback
  --     colors = {
  --       error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
  --       warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
  --       info = { "DiagnosticInfo", "#2563EB" },
  --       hint = { "DiagnosticHint", "#10B981" },
  --       default = { "Identifier", "#7C3AED" },
  --       test = { "Identifier", "#FF00FF" },
  --     },
  --     search = {
  --       command = "rg",
  --       args = {
  --         "--color=never",
  --         "--no-heading",
  --         "--with-filename",
  --         "--line-number",
  --         "--column",
  --       },
  --       -- regex that will be used to match keywords.
  --       pattern = [[\b(KEYWORDS):]], -- ripgrep regex
  --     },
  --   },
  --   keys = {
  --     {
  --       "]t",
  --       function()
  --         require("todo-comments").jump_next()
  --       end,
  --       desc = "Next todo comment",
  --     },
  --     {
  --       "[t",
  --       function()
  --         require("todo-comments").jump_prev()
  --       end,
  --       desc = "Previous todo comment",
  --     },
  --     { "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
  --     { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
  --     { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo" },
  --     { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme" },
  --   },
  --
  --   -- Add custom command for git diff todos
  --   config = function(_, opts)
  --     require("todo-comments").setup(opts)
  --   end,
  -- },
}
