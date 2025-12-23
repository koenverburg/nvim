-- vim.api.nvim_set_hl(0, "BlinkCmpMenuSelection", {
--   underline = false,
-- })

local blink = require("blink.cmp")

blink.setup({
  keymap = {
    preset = "enter",
    ["<C-y>"] = { "select_and_accept" },
    -- ["<C><space>"] = { "show"}
  },

  appearance = {
    nerd_font_variant = "mono",
    use_nvim_cmp_as_default = true,
  },

  signature = {
    -- border = 'rounded',
    enabled = true,
  },

  completion = {
    ghost_text = { enabled = true },

    menu = {
      border = "rounded",

      draw = {
        columns = {
          { "kind_icon", gap = 2 },
          { "label", gap = 2 },
          { "label_detail", gap = 1 },
          { "label_description" },
        },

        components = {
          label = {
            width = { fill = true }, -- max = 60
            text = function(ctx)
              return ctx.label
            end,
            highlight = function(ctx)
              local highlights = {}
              local highlights_info = require("colorful-menu").blink_highlights(ctx)
              if highlights_info ~= nil then
                highlights = highlights_info.highlights
              end
              for _, idx in ipairs(ctx.label_matched_indices) do
                table.insert(highlights, { idx, idx + 1, group = "BlinkCmpLabelMatch" })
              end
              return highlights
            end,
          },

          label_detail = {
            width = { max = 30 },
            text = function(ctx)
              return ctx.label_detail or ""
            end,
            highlight = function(ctx)
              local count = ctx.label_detail or ""
              return { { 1, #count, group = "Comment" } }
            end,
          },
        },
      },
    },

    documentation = {
      auto_show = true,
      auto_show_delay_ms = 200,
      window = {
        border = "rounded",
      },
    },
  },

  sources = {
    -- Add 'avante' to the list
    default = { "avante", "lsp", "path", "snippets", "buffer" },
    providers = {
      avante = {
        module = "blink-cmp-avante",
        name = "Avante",
        opts = {
          -- options for blink-cmp-avante
        },
      },
    },
  },

  fuzzy = { implementation = "prefer_rust_with_warning", use_proximity = true },
})
