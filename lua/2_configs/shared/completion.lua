-- Shared completion configuration utilities
local M = {}

-- Common completion sources for different completion engines
M.common_sources = {
  lsp = { name = "nvim_lsp", priority = 1000 },
  buffer = { name = "buffer", keyword_length = 5, priority = 500 },
  path = { name = "path", priority = 300 },
  snippets = { name = "luasnip", priority = 750 },
  nvim_lua = { name = "nvim_lua", priority = 800 },
}

-- Common window configuration for completion menus
M.window_config = {
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
    max_height = math.floor(vim.o.lines * 0.4),
    max_width = math.floor(vim.o.columns * 0.8),
  },
}

-- Common keymap patterns for completion
M.common_keymaps = {
  ["<C-n>"] = "select_next",
  ["<C-p>"] = "select_prev",
  ["<C-y>"] = "confirm",
  ["<Tab>"] = "confirm",
  ["<C-e>"] = "abort",
  ["<C-b>"] = "scroll_docs_up",
  ["<C-f>"] = "scroll_docs_down",
  ["<C-Space>"] = "complete",
}

-- LSP kind icons for consistent display
M.kind_icons = {
  Text = "󰉿",
  Method = "󰆧",
  Function = "󰊕",
  Constructor = "",
  Field = "󰜢",
  Variable = "󰀫",
  Class = "󰠱",
  Interface = "",
  Module = "",
  Property = "󰜢",
  Unit = "󰑭",
  Value = "󰎠",
  Enum = "",
  Keyword = "󰌋",
  Snippet = "",
  Color = "󰏘",
  File = "󰈙",
  Reference = "󰈇",
  Folder = "󰉋",
  EnumMember = "",
  Constant = "󰏿",
  Struct = "󰙅",
  Event = "",
  Operator = "󰆕",
  TypeParameter = "",
}

-- Common completion sorting priorities
M.kind_priority = {
  Variable = 1,
  Function = 2,
  Method = 2,
  Field = 3,
  Property = 3,
  Constant = 4,
  Constructor = 5,
  Class = 6,
  Interface = 7,
  Module = 8,
  Keyword = 9,
  Text = 10,
  Snippet = 11,
}

-- Format completion item with icon and kind
function M.format_item(entry, vim_item)
  if M.kind_icons[vim_item.kind] then
    vim_item.kind = M.kind_icons[vim_item.kind] .. " " .. vim_item.kind
  end

  -- Truncate long labels
  if vim_item.abbr and #vim_item.abbr > 50 then
    vim_item.abbr = string.sub(vim_item.abbr, 1, 47) .. "..."
  end

  return vim_item
end

-- Get sources for CMP
function M.get_cmp_sources()
  return {
    M.common_sources.lsp,
    M.common_sources.snippets,
    M.common_sources.nvim_lua,
    M.common_sources.path,
    M.common_sources.buffer,
  }
end

-- Get sources for Blink
function M.get_blink_sources()
  return { "lsp", "buffer", "path", "snippets" }
end

return M
