-- File = 1;
-- Module = 2;
-- Namespace = 3;
-- Package = 4;
-- Class = 5;
-- Method = 6;
-- Property = 7;
-- Field = 8;
-- Constructor = 9;
-- Enum = 10;
-- Interface = 11;
-- Function = 12;
-- Variable = 13;
-- Constant = 14;
-- String = 15;
-- Number = 16;
-- Boolean = 17;
-- Array = 18;
-- Object = 19;
-- Key = 20;
-- Null = 21;
-- EnumMember = 22;
-- Struct = 23;
-- Event = 24;
-- Operator = 25;
-- TypeParameter = 26;

return {
  "romus204/referencer.nvim",
  lazy = false,
  enabled = false,
  event = LoadOnBuffer,
  config = function()
    require("referencer").setup({
      enable = true, -- enable after LSP attach
      format = " %d usage(s)", -- format string for reference count
      show_no_reference = true, -- show if refs count = 0
      kinds = { 6, 7, 10, 15, 23, 26 }, -- LSP SymbolKinds to show references for
      -- kinds = { 5, 6, 8, 12, 13, 14, 23 }, -- LSP SymbolKinds to show references for
      hl_group = "Comment", -- default highlight group
      color = nil, -- optional custom color (overrides hl_group)
      virt_text_pos = "eol", -- virtual text position (eol | overlay | right_align)
      pattern = {
        "*.ts",
        "*.tsx",
      }, -- pattern for LspAttach autocmd to auto-enable
      lsp_servers = nil, -- list of servers for which this plugin will be active. nil or {} is ALL LSP clients
    })
  end,
}
