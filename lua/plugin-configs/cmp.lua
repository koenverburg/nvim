local core = require("core.config")

local cmp = require("cmp")
local lspkind = require("lspkind")

cmp.setup({
  completion = { completeopt = "menu,menuone,noinsert" },
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
    ["<C-y>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
    ["<Tab>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
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
  window = {
    completion = {
      border = "rounded",
      winhighlight = "Normal:CmpNormal,FloatBorder:None",
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
  experimental = {
    native_menu = false,
    ghost_text = { hl_group = "CmpGhostText" },
  },
})
