local M = {}

function M.setup()
  vim.cmd("hi clear")
  if vim.fn.exists("syntax_on") then
    vim.cmd("syntax reset")
  end

  vim.o.termguicolors = true
  vim.g.colors_name = "custom-quiet"

  vim.o.background = "dark"

  local bg = vim.o.background
  local is_dark = bg == "dark"

  -- Color palette
  local colors = {}

  if is_dark then
    -- Dark mode colors
    colors.bg = "#000000"
    colors.bg_alt = "#121212"
    colors.fg = "#aaaaaa"
    colors.fg_dim = "#777777"
    colors.fg_bright = "#dddddd"

    -- Subtle accents from no-clown-fiesta and black metal bathory
    colors.red = "#d16969"
    colors.green = "#8c9440"
    colors.yellow = "#d7ba7d"
    colors.blue = "#8b7d6b"
    colors.magenta = "#a07878"
    colors.cyan = "#7a8b7d"
    colors.orange = "#ce9178"

    -- Diagnostic colors from no-clown-fiesta
    colors.error = "#d16969"
    colors.warning = "#d7ba7d"
    colors.info = "#608b9e"
    colors.hint = "#4d8f8f"
  else
    -- Light mode colors
    colors.bg = "#f5f5f5"
    colors.bg_alt = "#e8e8e8"
    colors.fg = "#4a4a4a"
    colors.fg_dim = "#777777"
    colors.fg_bright = "#222222"

    -- Light mode accents
    colors.red = "#af3a03"
    colors.green = "#5f6f2f"
    colors.yellow = "#b57614"
    colors.blue = "#076678"
    colors.magenta = "#8f3f71"
    colors.cyan = "#427b58"
    colors.orange = "#af5f00"

    -- Diagnostic colors for light mode
    colors.error = "#af3a03"
    colors.warning = "#b57614"
    colors.info = "#076678"
    colors.hint = "#427b58"
  end

  local function hl(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  -- Editor highlights
  hl("Normal", { fg = colors.fg, bg = colors.bg })
  hl("NormalFloat", { fg = colors.fg, bg = colors.bg_alt })
  hl("NormalNC", { fg = colors.fg, bg = colors.bg })
  hl("LineNr", { fg = colors.fg_dim })
  hl("CursorLine", { bg = colors.bg_alt })
  hl("CursorLineNr", { fg = colors.fg_bright })
  hl("Visual", { bg = colors.bg_alt, reverse = true })
  hl("Search", { fg = colors.bg, bg = colors.yellow })
  hl("IncSearch", { fg = colors.bg, bg = colors.orange })
  hl("Pmenu", { fg = colors.fg, bg = colors.bg_alt })
  hl("PmenuSel", { fg = colors.fg_bright, bg = colors.bg_alt, reverse = true })
  hl("StatusLine", { fg = colors.fg, bg = colors.bg_alt })
  hl("StatusLineNC", { fg = colors.fg_dim, bg = colors.bg_alt })
  hl("VertSplit", { fg = colors.fg_dim })
  hl("WinSeparator", { fg = colors.fg_dim })
  hl("Folded", { fg = colors.fg_dim, bg = colors.bg_alt })
  hl("SignColumn", { bg = colors.bg })
  hl("ColorColumn", { bg = colors.bg_alt })

  -- Syntax highlights
  hl("Comment", { fg = colors.fg_dim, italic = true })
  hl("Constant", { fg = colors.cyan })
  hl("String", { fg = colors.green })
  hl("Character", { fg = colors.green })
  hl("Number", { fg = colors.cyan })
  hl("Boolean", { fg = colors.cyan })
  hl("Float", { fg = colors.cyan })

  hl("Identifier", { fg = colors.fg })
  hl("Function", { fg = colors.blue })

  hl("Statement", { fg = colors.magenta, bold = true })
  hl("Conditional", { fg = colors.magenta, bold = true })
  hl("Repeat", { fg = colors.magenta, bold = true })
  hl("Label", { fg = colors.magenta, bold = true })
  hl("Operator", { fg = colors.fg })
  hl("Keyword", { fg = colors.magenta, bold = true })
  hl("Exception", { fg = colors.red, bold = true })

  hl("PreProc", { fg = colors.blue })
  hl("Include", { fg = colors.blue })
  hl("Define", { fg = colors.blue })
  hl("Macro", { fg = colors.blue })
  hl("PreCondit", { fg = colors.blue })

  hl("Type", { fg = colors.yellow, bold = true })
  hl("StorageClass", { fg = colors.yellow, bold = true })
  hl("Structure", { fg = colors.yellow, bold = true })
  hl("Typedef", { fg = colors.yellow, bold = true })

  hl("Special", { fg = colors.orange })
  hl("SpecialChar", { fg = colors.orange })
  hl("Tag", { fg = colors.blue })
  hl("Delimiter", { fg = colors.fg })
  hl("SpecialComment", { fg = colors.fg_dim, italic = true })
  hl("Debug", { fg = colors.red })

  hl("Underlined", { underline = true })
  hl("Error", { fg = colors.error })
  hl("Todo", { fg = colors.bg, bg = colors.yellow, bold = true })

  -- Treesitter highlights
  hl("@variable", { fg = colors.fg })
  hl("@variable.builtin", { fg = colors.cyan })
  hl("@variable.parameter", { fg = colors.fg })
  hl("@variable.member", { fg = colors.fg })

  hl("@constant", { fg = colors.cyan })
  hl("@constant.builtin", { fg = colors.cyan })
  hl("@constant.macro", { fg = colors.blue })

  hl("@string", { fg = colors.green })
  hl("@string.escape", { fg = colors.orange })
  hl("@string.special", { fg = colors.orange })
  hl("@character", { fg = colors.green })
  hl("@number", { fg = colors.cyan })
  hl("@boolean", { fg = colors.cyan })
  hl("@float", { fg = colors.cyan })

  hl("@function", { fg = colors.blue })
  hl("@function.builtin", { fg = colors.blue })
  hl("@function.macro", { fg = colors.blue })
  hl("@function.method", { fg = colors.blue })

  hl("@constructor", { fg = colors.yellow })
  hl("@parameter", { fg = colors.fg })

  hl("@keyword", { fg = colors.magenta, bold = true })
  hl("@keyword.function", { fg = colors.magenta, bold = true })
  hl("@keyword.operator", { fg = colors.magenta, bold = true })
  hl("@keyword.return", { fg = colors.magenta, bold = true })
  hl("@keyword.conditional", { fg = colors.magenta, bold = true })
  hl("@keyword.repeat", { fg = colors.magenta, bold = true })
  hl("@keyword.import", { fg = colors.blue })

  hl("@conditional", { fg = colors.magenta, bold = true })
  hl("@repeat", { fg = colors.magenta, bold = true })
  hl("@label", { fg = colors.magenta })
  hl("@operator", { fg = colors.fg })
  hl("@exception", { fg = colors.red, bold = true })

  hl("@type", { fg = colors.yellow, bold = true })
  hl("@type.builtin", { fg = colors.yellow, bold = true })
  hl("@type.definition", { fg = colors.yellow, bold = true })
  hl("@type.qualifier", { fg = colors.magenta, bold = true })

  hl("@storageclass", { fg = colors.yellow, bold = true })
  hl("@structure", { fg = colors.yellow, bold = true })
  hl("@namespace", { fg = colors.fg })

  hl("@include", { fg = colors.blue })
  hl("@preproc", { fg = colors.blue })
  hl("@define", { fg = colors.blue })
  hl("@macro", { fg = colors.blue })

  hl("@comment", { fg = colors.fg_dim, italic = true })
  hl("@comment.documentation", { fg = colors.fg_dim, italic = true })

  hl("@tag", { fg = colors.blue })
  hl("@tag.attribute", { fg = colors.fg })
  hl("@tag.delimiter", { fg = colors.fg_dim })

  hl("@punctuation.delimiter", { fg = colors.fg })
  hl("@punctuation.bracket", { fg = colors.fg })
  hl("@punctuation.special", { fg = colors.orange })

  -- Diagnostic highlights (from no-clown-fiesta)
  hl("DiagnosticError", { fg = colors.error })
  hl("DiagnosticWarn", { fg = colors.warning })
  hl("DiagnosticInfo", { fg = colors.info })
  hl("DiagnosticHint", { fg = colors.hint })

  hl("DiagnosticUnderlineError", { undercurl = true, sp = colors.error })
  hl("DiagnosticUnderlineWarn", { undercurl = true, sp = colors.warning })
  hl("DiagnosticUnderlineInfo", { undercurl = true, sp = colors.info })
  hl("DiagnosticUnderlineHint", { undercurl = true, sp = colors.hint })

  hl("DiagnosticVirtualTextError", { fg = colors.error })
  hl("DiagnosticVirtualTextWarn", { fg = colors.warning })
  hl("DiagnosticVirtualTextInfo", { fg = colors.info })
  hl("DiagnosticVirtualTextHint", { fg = colors.hint })

  -- Telescope highlights
  hl("TelescopeBorder", { fg = colors.fg_dim, bg = colors.bg })
  hl("TelescopeNormal", { fg = colors.fg, bg = colors.bg })
  hl("TelescopeSelection", { fg = colors.fg_bright, bg = colors.bg_alt, bold = true })
  hl("TelescopeSelectionCaret", { fg = colors.blue, bg = colors.bg_alt })
  hl("TelescopeMultiSelection", { fg = colors.magenta, bg = colors.bg_alt })
  hl("TelescopeMatching", { fg = colors.orange, bold = true })
  hl("TelescopePromptPrefix", { fg = colors.blue })
  hl("TelescopePromptCounter", { fg = colors.fg_dim })
  hl("TelescopeTitle", { fg = colors.blue, bold = true })

  -- Lualine highlights
  hl("lualine_a_normal", { fg = colors.bg, bg = colors.blue, bold = true })
  hl("lualine_b_normal", { fg = colors.fg, bg = colors.bg_alt })
  hl("lualine_c_normal", { fg = colors.fg_dim, bg = colors.bg })

  hl("lualine_a_insert", { fg = colors.bg, bg = colors.green, bold = true })
  hl("lualine_b_insert", { fg = colors.fg, bg = colors.bg_alt })
  hl("lualine_c_insert", { fg = colors.fg_dim, bg = colors.bg })

  hl("lualine_a_visual", { fg = colors.bg, bg = colors.magenta, bold = true })
  hl("lualine_b_visual", { fg = colors.fg, bg = colors.bg_alt })
  hl("lualine_c_visual", { fg = colors.fg_dim, bg = colors.bg })

  hl("lualine_a_replace", { fg = colors.bg, bg = colors.red, bold = true })
  hl("lualine_b_replace", { fg = colors.fg, bg = colors.bg_alt })
  hl("lualine_c_replace", { fg = colors.fg_dim, bg = colors.bg })

  hl("lualine_a_command", { fg = colors.bg, bg = colors.yellow, bold = true })
  hl("lualine_b_command", { fg = colors.fg, bg = colors.bg_alt })
  hl("lualine_c_command", { fg = colors.fg_dim, bg = colors.bg })

  hl("lualine_a_inactive", { fg = colors.fg_dim, bg = colors.bg_alt })
  hl("lualine_b_inactive", { fg = colors.fg_dim, bg = colors.bg })
  hl("lualine_c_inactive", { fg = colors.fg_dim, bg = colors.bg })

  -- Lualine diagnostics
  hl("lualine_diagnostics_error_normal", { fg = colors.error, bg = colors.bg_alt })
  hl("lualine_diagnostics_warn_normal", { fg = colors.warning, bg = colors.bg_alt })
  hl("lualine_diagnostics_info_normal", { fg = colors.info, bg = colors.bg_alt })
  hl("lualine_diagnostics_hint_normal", { fg = colors.hint, bg = colors.bg_alt })

  -- Hop highlights (bright and standout)
  if is_dark then
    hl("HopNextKey", { fg = "#ff007c", bg = colors.bg, bold = true, underline = true })
    hl("HopNextKey1", { fg = "#00dfff", bg = colors.bg, bold = true })
    hl("HopNextKey2", { fg = "#2bff88", bg = colors.bg, bold = true })
    hl("HopUnmatched", { fg = "#3a3a3a", bg = colors.bg })
    hl("HopCursor", { fg = "#ff007c", bg = colors.bg, bold = true, reverse = true })
    hl("HopPreview", { fg = "#ffff00", bg = colors.bg, bold = true, underline = true })
  else
    hl("HopNextKey", { fg = "#d70087", bg = colors.bg, bold = true, underline = true })
    hl("HopNextKey1", { fg = "#0087d7", bg = colors.bg, bold = true })
    hl("HopNextKey2", { fg = "#00af5f", bg = colors.bg, bold = true })
    hl("HopUnmatched", { fg = "#bcbcbc", bg = colors.bg })
    hl("HopCursor", { fg = "#d70087", bg = colors.bg, bold = true, reverse = true })
    hl("HopPreview", { fg = "#af8700", bg = colors.bg, bold = true, underline = true })
  end

  -- LSP semantic tokens
  hl("@lsp.type.class", { link = "@type" })
  hl("@lsp.type.decorator", { link = "@function" })
  hl("@lsp.type.enum", { link = "@type" })
  hl("@lsp.type.enumMember", { link = "@constant" })
  hl("@lsp.type.function", { link = "@function" })
  hl("@lsp.type.interface", { link = "@type" })
  hl("@lsp.type.macro", { link = "@macro" })
  hl("@lsp.type.method", { link = "@function.method" })
  hl("@lsp.type.namespace", { link = "@namespace" })
  hl("@lsp.type.parameter", { link = "@parameter" })
  hl("@lsp.type.property", { link = "@variable.member" })
  hl("@lsp.type.struct", { link = "@type" })
  hl("@lsp.type.type", { link = "@type" })
  hl("@lsp.type.typeParameter", { link = "@type" })
  hl("@lsp.type.variable", { link = "@variable" })
end

M.setup()

return M
