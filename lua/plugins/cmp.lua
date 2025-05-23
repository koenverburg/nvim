require("globals")
local core = require("core.config")

local lspkind_comparator = function(conf)
  local lsp_types = require("cmp.types").lsp
  return function(entry1, entry2)
    if entry1.source.name ~= "nvim_lsp" then
      if entry2.source.name == "nvim_lsp" then
        return false
      else
        return nil
      end
    end
    local kind1 = lsp_types.CompletionItemKind[entry1:get_kind()]
    local kind2 = lsp_types.CompletionItemKind[entry2:get_kind()]
    if kind1 == "Variable" and entry1:get_completion_item().label:match("%w*=") then
      kind1 = "Parameter"
    end
    if kind2 == "Variable" and entry2:get_completion_item().label:match("%w*=") then
      kind2 = "Parameter"
    end

    local priority1 = conf.kind_priority[kind1] or 0
    local priority2 = conf.kind_priority[kind2] or 0
    if priority1 == priority2 then
      return nil
    end
    return priority2 < priority1
  end
end

local label_comparator = function(entry1, entry2)
  return entry1.completion_item.label < entry2.completion_item.label
end

return {
  "hrsh7th/nvim-cmp",
  event = LoadOnBuffer,
  enabled = false, -- Is_enabled("lsp"),
  dependencies = {
    "mason.nvim",
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-nvim-lsp",
    "onsails/lspkind-nvim",
    "saadparwaiz1/cmp_luasnip",
    "L3MON4D3/LuaSnip",
  },
  config = function()
    local cmp = require("cmp")
    local lspkind = require("lspkind")
    local cmp_window = require("cmp.config.window")

    cmp.setup({
      completion = {
        completeopt = "menu,menuone,noinsert",
      },
      comparators = {
        lspkind_comparator({
          kind_priority = {
            Parameter = 14,
            Variable = 12,
            Field = 11,
            Property = 11,
            Constant = 10,
            Enum = 10,
            -- EnumMember = 10,
            -- Event = 10,
            -- Function = 10,
            -- Method = 10,
            -- Operator = 10,
            -- Reference = 10,
            -- Struct = 10,
            -- File = 8,
            -- Folder = 8,
            -- Class = 5,
            -- Color = 5,
            -- Module = 5,
            -- Keyword = 2,
            -- Constructor = 1,
            -- Interface = 1,
            -- Snippet = 0,
            -- Text = 1,
            -- TypeParameter = 1,
            -- Unit = 1,
            -- Value = 1,
          },
        }),
        -- label_comparator,
      },
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
        -- ["<tab>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        ["<C-y>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        ["<Tab>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.

        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
      }),
      sources = cmp.config.sources({
        { name = "luasnip" },
        { name = "nvim_lsp" },
        { name = "nvim_lua" },
        { name = "path" },
        { name = "buffer", keyword_length = 5 },
      }),
      confirm_opts = {
        behavior = cmp.ConfirmBehavior.Replace,
        select = false,
      },
      view = {
        entries = {
          name = "custom",
          follow_cursor = true,
          selection_order = "near_cursor",
        },
      },
      window = {
        -- documentation = cmp.config.window.bordered(),
        -- completion = cmp.config.window.bordered({
        --   border = "rounded",
        --   winhighlight = "Normal:CmpPmenu,CursorLine:PmenuSel,Search:None",
        -- }),
        completion = {
          border = "rounded",
          winhighlight = "Normal:CmpNormal,FloatBorder:None",
          -- winhighlight = "Normal:Pmenu,CursorLine:PmenuSel,FloatBorder:FloatBorder,Search:None",
          col_offset = -3,
          side_padding = 1,
          scrollbar = false,
          scrolloff = 8,
        },
        documentation = {
          border = "rounded",
          winhighlight = "Normal:CmpNormal,FloatBorder:None",
        },
      },
      sorting = {
        -- TODO: Would be cool to add stuff like "See variable names before method names", or something like that.
        comparators = {
          cmp.config.compare.offset,
          cmp.config.compare.exact,
          cmp.config.compare.score,

          -- copied from cmp-under, but I don't think I need the plugin for this.
          -- I might add some more of my own.
          function(entry1, entry2)
            local _, entry1_under = entry1.completion_item.label:find("^_+")
            local _, entry2_under = entry2.completion_item.label:find("^_+")
            entry1_under = entry1_under or 0
            entry2_under = entry2_under or 0
            if entry1_under > entry2_under then
              return false
            elseif entry1_under < entry2_under then
              return true
            end
          end,

          cmp.config.compare.kind,
          cmp.config.compare.sort_text,
          cmp.config.compare.length,
          cmp.config.compare.order,
        },
      },
      -- formatting = {
      --   expandable_indicator = false,
      --   fields = { "kind", "abbr", "menu" },
      --   format = lspkind.cmp_format({
      --     mode = "symbol",
      --     maxwidth = 30,
      --     ellipsis_char = "...",
      --     show_labelDetails = true,
      --     before = function(_, item)
      --       return item
      --     end,
      --   }),
      -- },
      -- formatting = {
      --   fields = { "kind", "abbr", "menu" },
      --   format = function(entry, vim_item)
      --     vim_item.kind = (core.icons[vim_item.kind] or "?") .. " " .. vim_item.kind
      --     -- vim_item.menu = entry.source.name
      --
      --     vim_item.abbr = vim_item.abbr:match("[^(]+")
      --
      --     return vim_item
      --   end,
      -- },
      experimental = {
        native_menu = false,
        ghost_text = {
          hl_group = "CmpGhostText",
        },
      },
    })
  end,
}
