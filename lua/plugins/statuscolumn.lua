local symbols = {
  foldopen = "▽",
  foldopen_alt = "╭",
  foldclose = "▶",
  foldclose_atl = "◆",
  foldsep = "│",
  foldmid = "┼",
  foldend = "╰",
}

return {
  "OXY2DEV/bars.nvim",
  lazy = false,
  enabled = false,
  config = function()
    local statuscolumn = require("bars.statuscolumn")
    statuscolumn = {
      force_attach = {},

      ignore_filetypes = { "blink-cmp-menu" },
      ignore_buftypes = { "help", "quickfix" },

      condition = function(buffer)
        local ft, bt = vim.bo[buffer].ft, vim.bo[buffer].bt

        if bt == "nofile" and ft == "query" then
          --- Buffer for `:InspectTree`
          return true
        elseif bt == "nofile" then
          --- Normal nofile buffer.
          return false
        else
          return true
        end
      end,

      default = {
        components = {
          ---|fS

          -- {
          --   kind = "empty",
          --   width = 1,
          --
          --   hl = "LineNr",
          -- },
          -- {
          --   kind = "signs",
          --   hl = "LineNr",
          --
          --   filter = function(buffer, namespaces, _, _, _, details)
          --     ---@type string
          --     local mode = vim.api.nvim_get_mode().mode
          --     local name = namespaces[details.ns_id] or ""
          --
          --     if package.loaded["markview"] and vim.bo[buffer].ft == "markdown" then
          --       --- On markdown files when on normal
          --       --- mode only show markview signs.
          --       if mode == "n" then
          --         return string.match(name, "^markview") ~= nil
          --       else
          --         return true
          --       end
          --     elseif package.loaded["helpview"] and vim.bo[buffer].ft == "help" then
          --       --- On help files when on normal
          --       --- mode only show helpview signs.
          --       if mode == "n" then
          --         return string.match(name, "^helpview") ~= nil
          --       else
          --         return true
          --       end
          --     else
          --       if vim.list_contains({ "i", "v", "V", "" }, mode) then
          --         --- On visual mode only show git signs.
          --         return string.match(name, "^gitsigns") ~= nil
          --       end
          --
          --       return true
          --     end
          --   end,
          -- },
          {
            kind = "folds",

            close_text = { symbols.foldclose_atl },
            close_hl = {
              "Comment",
              --   "BarsFoldClose1",
              --   "BarsFoldClose2",
              --   "BarsFoldClose3",
              --   "BarsFoldClose4",
              --   "BarsFoldClose5",
              --   "BarsFoldClose6",
            },
            open_text = { symbols.foldopen_alt },
            open_hl = {
              "Comment",
              -- "BarsFoldOpen1",
              -- "BarsFoldOpen2",
              -- "BarsFoldOpen3",
              -- "BarsFoldOpen4",
              -- "BarsFoldOpen5",
              -- "BarsFoldOpen6",
            },

            scope_text = "│",
            scope_end_text = "╰",
            scope_merge_text = "├",

            fill_text = "",
            fill_hl = "LineNr",

            scope_hl = {
              "Comment",
              -- "BarsFoldOpen1",
              -- "BarsFoldOpen2",
              -- "BarsFoldOpen3",
              -- "BarsFoldOpen4",
              -- "BarsFoldOpen5",
              -- "BarsFoldOpen6",
            },
            scope_end_hl = {
              "Comment",
              -- "BarsFoldOpen1",
              -- "BarsFoldOpen2",
              -- "BarsFoldOpen3",
              -- "BarsFoldOpen4",
              -- "BarsFoldOpen5",
              -- "BarsFoldOpen6",
            },
            scope_merge_hl = {
              "Comment",
              -- "BarsFoldOpen1",
              -- "BarsFoldOpen2",
              -- "BarsFoldOpen3",
              -- "BarsFoldOpen4",
              -- "BarsFoldOpen5",
              -- "BarsFoldOpen6",
            },
          },
          {
            kind = "empty",
            width = 1,
            hl = "LineNr",
          },
          {
            kind = "lnum",
            mode = 3,

            click = function(_, window)
              return window == vim.api.nvim_get_current_win()
            end,

            wrap_markers = "│",
            virt_markers = "│",

            wrap_hl = {
              "BarsWrap1",
              "BarsWrap2",
              "BarsWrap3",
              "BarsWrap4",
              "BarsWrap5",
            },
            virt_hl = {
              "BarsVirtual1",
              "BarsVirtual2",
              "BarsVirtual3",
              "BarsVirtual4",
              "BarsVirtual5",
            },
            hl = function()
              ---@type string
              local mode = vim.api.nvim_get_mode().mode
              local USE = gradient_map[mode] or gradient_map.default

              return {
                string.format(USE, 1),
                "LineNr",
              }
            end,
          },
          -- {
          --   kind = "border",
          --   text = "▕",
          --   hl = function()
          --     local _o = {}
          --     ---@type string
          --     local mode = vim.api.nvim_get_mode().mode
          --     local USE = gradient_map[mode] or gradient_map.default
          --
          --     for g = 1, 7 do
          --       table.insert(_o, string.format(USE, g))
          --     end
          --
          --     return _o
          --   end,
          -- },
          {
            kind = "empty",
            width = 1,
            hl = "Normal",
          },

          ---|fE
        },
      },

      inspect_tree = {
        ---|fS

        condition = function(buffer, window)
          if vim.b[buffer].dev_base then
            return true
          elseif vim.w[window].inspecttree_window then
            return true
          end

          return false
        end,

        components = {
          {
            kind = "custom",
            value = function(buffer)
              local lnums = vim.b[buffer].injections or {}
              local current = lnums[vim.v.lnum] or "LineNr"

              return "%#" .. current .. "# "
            end,
          },
        },

        ---|fE
      },

      terminal = {
        ---|fS

        condition = function(buffer)
          return vim.bo[buffer].bt == "terminal"
        end,

        components = {},

        ---|fE
      },
    }

    require("bars").setup({
      global = true,

      winbar = false,
      tabline = false,
      statusline = false,
      statuscolumn = statuscolumn,
    })

    vim.opt.signcolumn = "yes"
  end,
}
