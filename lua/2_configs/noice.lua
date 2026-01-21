local noice = require("noice")

noice.setup({
  lsp = {
    override = {
      ["vim.lsp.handlers['textDocument/hover']"] = false,
      ["vim.lsp.handlers['textDocument/signatureHelp']"] = false,
    },
    hover = {
      enabled = false,
    },
    signature = {
      enabled = false,
    },
  },
  cmdline = {
    enabled = true, -- enables the Noice cmdline UI
    view = "cmdline_popup", -- view for rendering the cmdline. Change to `cmdline` to get a classic cmdline at the bottom
    format = {
      help = { pattern = "^:%s*he?l?p?%s+", icon = "" },
      cmdline = { pattern = "^:", icon = ">", lang = "vim" },
      filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
      lua = { pattern = "^:%s*lua%s+", icon = "", lang = "lua" },
      search_up = { kind = "search", pattern = "^%?", icon = "", lang = "regex" },
      search_down = { kind = "search", pattern = "^/", icon = "", lang = "regex" },
      -- input = {}, -- Used by input()
    },
  },
  -- cmdline_popupmenu = {
  --   -- relative = "editor",
  --   -- position = {
  --   --   row = 13,
  --   --   col = "50%",
  --   -- },
  --   -- size = {
  --   --   width = 60,
  --   --   height = "auto",
  --   --   max_height = 15,
  --   -- },
  --   border = {
  --     style = "none",
  --     padding = { 0, 3 },
  --   },
  --   win_options = {
  --     winhighlight = { NormalFloat = "NormalFloat", FloatBorder = "NoiceCmdlinePopupBorder" },
  --   },
  -- },
})
