local config = require("core.config")

return {
  {
    "pmouraguedes/neodarcula.nvim",
    lazy = false,
    enabled = false,
    priority = 1000,
    opts = {
      transparent = false, -- Enable transparent background
      dim = true, -- Dim inactive windows with a black background
    },
  },

  -- return {
  --   "stevedylandev/darkmatter-nvim",
  --   lazy = false,
  --   enabled = true,
  --   priority = 1000,
  --   config = function()
  --     vim.cmd("colorscheme darkmatter")
  --   end,
  -- }

  -- return {
  --   "AlexvZyl/nordic.nvim",
  --   lazy = false,
  --   enabled = true,
  --   priority = 1000,
  --   config = function()
  --     require("nordic").setup({
  --       -- This callback can be used to override the colors used in the base palette.
  --       -- on_palette = function(palette) end,
  --       -- This callback can be used to override the colors used in the extended palette.
  --       -- after_palette = function(palette) end,
  --       -- This callback can be used to override highlights before they are applied.
  --       -- on_highlight = function(highlights, palette) end,
  --       -- Enable bold keywords.
  --       bold_keywords = true,
  --       -- Enable italic comments.
  --       italic_comments = false,
  --       -- Enable editor background transparency.
  --       transparent = {
  --         -- Enable transparent background.
  --         bg = false,
  --         -- Enable transparent background for floating windows.
  --         float = false,
  --       },
  --       -- Enable brighter float border.
  --       bright_border = true,
  --       -- Reduce the overall amount of blue in the theme (diverges from base Nord).
  --       reduced_blue = true,
  --       -- Swap the dark background with the normal one.
  --       swap_backgrounds = false,
  --       -- Cursorline options.  Also includes visual/selection.
  --       cursorline = {
  --         -- Bold font in cursorline.
  --         bold = false,
  --         -- Bold cursorline number.
  --         bold_number = true,
  --         -- Available styles: 'dark', 'light'.
  --         theme = "dark",
  --         -- Blending the cursorline bg with the buffer bg.
  --         blend = 0.85,
  --       },
  --       noice = {
  --         -- Available styles: `classic`, `flat`.
  --         style = "classic",
  --       },
  --       telescope = {
  --         -- Available styles: `classic`, `flat`.
  --         style = "classic",
  --       },
  --       leap = {
  --         -- Dims the backdrop when using leap.
  --         dim_backdrop = false,
  --       },
  --       ts_context = {
  --         -- Enables dark background for treesitter-context window
  --         dark_background = true,
  --       },
  --     })
  --     vim.cmd([[ colorscheme nordic ]])
  --   end,
  -- }

  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    enabled = true,
    priority = 1000,
    config = function()
      require("rose-pine").setup({
        variant = "main", -- auto, main, moon, or dawn
        dark_variant = "main", -- main, moon, or dawn
        dim_inactive_windows = true,
        extend_background_behind_borders = true,

        enable = {
          terminal = true,
          legacy_highlights = false, -- Improve compatibility for previous versions of Neovim
          migrations = true, -- Handle deprecated options automatically },
        },

        styles = {
          bold = true,
          italic = false,
          transparency = false,
        },

        -- groups = {
        --   border = "muted",
        --   link = "iris",
        --   panel = "surface",
        --
        --   error = "love",
        --   hint = "iris",
        --   info = "foam",
        --   note = "pine",
        --   todo = "rose",
        --   warn = "gold",
        --
        --   git_add = "foam",
        --   git_change = "rose",
        --   git_delete = "love",
        --   git_dirty = "rose",
        --   git_ignore = "muted",
        --   git_merge = "iris",
        --   git_rename = "pine",
        --   git_stage = "iris",
        --   git_text = "rose",
        --   git_untracked = "subtle",
        --
        --   h1 = "iris",
        --   h2 = "foam",
        --   h3 = "rose",
        --   h4 = "gold",
        --   h5 = "pine",
        --   h6 = "foam",
        -- },

        palette = {
          -- Override the builtin palette per variant
          -- moon = {
          --     base = '#18191a',
          --     overlay = '#363738',
          -- },
        },

        -- NOTE: Highlight groups are extended (merged) by default. Disable this
        -- per group via `inherit = false`
        highlight_groups = {
          -- CurSearch = { fg = "base", bg = "leaf", inherit = false },
          -- Search = { fg = "text", bg = "leaf", blend = 20, inherit = false },
          Search = { fg = config.colors.black, bg = config.colors.yellow, inherit = false },

          TelescopeSelection = { fg = config.colors.yellow },
          TelescopeSelectionCaret = { fg = config.colors.yellow },
          -- Comment = { fg = "foam" },
          -- StatusLine = { fg = "love", bg = "love", blend = 15 },
          -- VertSplit = { fg = "muted", bg = "muted" },
          -- Visual = { fg = "base", bg = "text", inherit = false },
        },

        before_highlight = function(group, highlight, palette)
          -- Disable all undercurls
          -- if highlight.undercurl then
          --     highlight.undercurl = false
          -- end
          --
          -- Change palette colour
          -- if highlight.fg == palette.pine then
          --     highlight.fg = palette.foam
          -- end
        end,
      })

      vim.cmd("colorscheme rose-pine")
    end,
  },
  -- require("neomodern").setup({
  --   style = "roseprime",
  --   -- UI options --
  --   ui = {
  --     telescope = "bordered", -- choose between 'borderless' or 'bordered'
  --     cmp_itemkind_reverse = false, -- reverse item kind highlights in cmp menu
  --     -- colored_docstrings = true, -- if true, docstrings will be highlighted like strings, otherwise they will be highlighted like comments
  --     -- plain = false, -- don't set background for search
  --     -- show_eob = true, -- show the end-of-buffer tildes
  --
  --     -- Plugins Related --
  --     plain_float = true,
  --     cmp = {
  --       plain = true,
  --     },
  --     -- lualine = {
  --     --   bold = false,
  --     --   plain = false, -- use a less distracting lualine. note: works best when no lualine separators are used
  --     -- },
  --     diagnostics = {
  --       darker = true, -- darker colors for diagnostic
  --       undercurl = true, -- use undercurl for diagnostics
  --       background = true, -- use background color for virtual text
  --     },
  --   },
  --   highlights = {
  --     Search = { fg = config.colors.black, bg = config.colors.yellow },
  --     -- TelescopeSelection = { fg = config.colors.yellow },
  --     TelescopeSelectionCaret = { fg = config.colors.yellow },
  --   },
  -- })
  -- require("neomodern").load()
  -- vim.cmd([[colorscheme roseprime]])
  -- end,
}
