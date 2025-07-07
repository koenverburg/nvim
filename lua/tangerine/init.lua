-- Tangerine colorscheme for Neovim
-- Converted from Emacs theme by Jasonm23 - 2012-07-02
-- Port to Neovim: 2025

local M = {}

-- Color palette extracted from the original Emacs theme
local colors = {
  -- Base colors
  bg = "#160a00", -- default background
  fg = "#FFaa78", -- default foreground

  -- Background variations
  bg_dark = "#1f0a00", -- fringe, mode-line background
  bg_lighter = "#201000", -- mode-line-inactive
  bg_selection = "#291000", -- region selection
  bg_secondary = "#502400", -- secondary-selection
  bg_linum = "#311000", -- line numbers background

  -- Orange/Brown color spectrum (main theme colors)
  orange_bright = "#FF6600", -- escape-glyph
  orange_main = "#ec5604", -- mode-line foreground
  orange_medium = "#DD6000", -- strings
  orange_warm = "#EE8800", -- constants
  orange_deep = "#cc6000", -- minibuffer-prompt, comment-delimiter
  orange_dark = "#d13000", -- linum foreground

  -- Brown spectrum
  brown_light = "#AE5200", -- types
  brown_medium = "#994800", -- keywords
  brown_dark = "#994000", -- variables
  brown_darker = "#7d3300", -- functions
  brown_deepest = "#6d3300", -- builtins
  brown_comment = "#572900", -- comments
  brown_muted = "#603000", -- fringe foreground, mode-line-inactive

  -- Special colors
  cursor_bg = "#4c2400", -- cursor background
  cursor_fg = "#ffffff", -- cursor foreground
  white = "#ffffff", -- minibuffer-message
  red = "#FF0000", -- warnings, errors

  -- UI colors
  powerline1 = "#6D3300",
  powerline2 = "#411E00",

  -- Highlight colors (from original theme)
  highlight_bg = "#004450", -- highlight background
  link_blue = "#0099aa", -- links
  search_fg = "#99ccee", -- isearch foreground
  search_bg = "#444444", -- isearch background
  lazy_highlight = "#77bbdd", -- lazy-highlight
  match_bg = "#3388cc", -- match background
}

-- Setup function
function M.setup(opts)
  opts = opts or {}

  -- Clear existing highlights
  vim.cmd("highlight clear")
  if vim.fn.exists("syntax_on") then
    vim.cmd("syntax reset")
  end

  -- Set colorscheme name and background
  vim.g.colors_name = "tangerine"
  vim.o.background = "dark"

  -- Define highlight groups
  local highlights = {
    -- Editor highlights
    Normal = { fg = colors.fg, bg = colors.bg },
    NormalFloat = { fg = colors.fg, bg = colors.bg_dark },
    NormalNC = { fg = colors.fg, bg = colors.bg },

    -- Cursor
    Cursor = { fg = colors.cursor_fg, bg = colors.cursor_bg },
    CursorLine = { bg = colors.bg_dark },
    CursorColumn = { bg = colors.bg_dark },
    ColorColumn = { bg = colors.bg_dark },

    -- Visual selection
    Visual = { bg = colors.bg_selection },
    VisualNOS = { bg = colors.bg_secondary },

    -- Line numbers (matching linum from original)
    LineNr = { fg = colors.orange_dark, bg = colors.bg_linum },
    CursorLineNr = { fg = colors.orange_main, bg = colors.bg_linum, bold = true },

    -- Folds
    Folded = { fg = colors.brown_comment, bg = colors.bg_dark },
    FoldColumn = { fg = colors.brown_muted, bg = colors.bg },

    -- Search (matching isearch from original)
    Search = { fg = colors.search_fg, bg = colors.search_bg },
    IncSearch = { fg = colors.search_fg, bg = colors.search_bg },
    CurSearch = { fg = colors.search_fg, bg = colors.search_bg },

    -- Status line (matching mode-line from original)
    StatusLine = { fg = colors.orange_main, bg = colors.bg_dark },
    StatusLineNC = { fg = colors.brown_muted, bg = colors.bg_lighter },

    -- Tab line
    TabLine = { fg = colors.brown_muted, bg = colors.bg_dark },
    TabLineFill = { bg = colors.bg_dark },
    TabLineSel = { fg = colors.orange_main, bg = colors.bg },

    -- Popup menu
    Pmenu = { fg = colors.fg, bg = colors.bg_dark },
    PmenuSel = { fg = colors.orange_main, bg = colors.bg_selection },
    PmenuSbar = { bg = colors.bg_lighter },
    PmenuThumb = { bg = colors.brown_muted },

    -- Messages
    ErrorMsg = { fg = colors.red },
    WarningMsg = { fg = colors.red, bold = true },
    ModeMsg = { fg = colors.white },
    MoreMsg = { fg = colors.orange_deep },

    -- Borders and separators
    VertSplit = { fg = colors.brown_muted },
    WinSeparator = { fg = colors.brown_muted },

    -- Syntax highlighting (matching font-lock faces)
    Comment = { fg = colors.brown_comment, italic = true },

    -- Constants (font-lock-constant-face)
    Constant = { fg = colors.orange_warm },
    String = { fg = colors.orange_medium }, -- font-lock-string-face
    Character = { fg = colors.orange_medium },
    Number = { fg = colors.orange_warm },
    Boolean = { fg = colors.orange_warm },
    Float = { fg = colors.orange_warm },

    -- Identifiers
    Identifier = { fg = colors.brown_dark }, -- font-lock-variable-name-face
    Function = { fg = colors.brown_darker }, -- font-lock-function-name-face

    -- Statements
    Statement = { fg = colors.brown_medium }, -- font-lock-keyword-face
    Conditional = { fg = colors.brown_medium },
    Repeat = { fg = colors.brown_medium },
    Label = { fg = colors.brown_medium },
    Operator = { fg = colors.orange_main },
    Keyword = { fg = colors.brown_medium },
    Exception = { fg = colors.brown_medium },

    -- Preprocessor (font-lock-preprocessor-face inherits builtin)
    PreProc = { fg = colors.brown_deepest }, -- font-lock-builtin-face
    Include = { fg = colors.brown_deepest },
    Define = { fg = colors.brown_deepest },
    Macro = { fg = colors.brown_deepest },
    PreCondit = { fg = colors.brown_deepest },

    -- Types (font-lock-type-face)
    Type = { fg = colors.brown_light },
    StorageClass = { fg = colors.brown_light },
    Structure = { fg = colors.brown_light },
    Typedef = { fg = colors.brown_light },

    -- Special
    Special = { fg = colors.orange_bright },
    SpecialChar = { fg = colors.orange_bright },
    Tag = { fg = colors.orange_main },
    Delimiter = { fg = colors.orange_deep },
    SpecialComment = { fg = colors.orange_deep, italic = true },
    Debug = { fg = colors.red },

    -- Underlines and errors
    Underlined = { fg = colors.link_blue, underline = true },
    Ignore = { fg = colors.brown_comment },
    Error = { fg = colors.red, bold = true },
    Todo = { fg = colors.orange_main, bold = true },

    -- Diff
    DiffAdd = { fg = colors.fg, bg = colors.brown_deepest },
    DiffChange = { fg = colors.fg, bg = colors.brown_medium },
    DiffDelete = { fg = colors.red, bg = colors.bg_dark },
    DiffText = { fg = colors.orange_main, bg = colors.brown_dark },

    -- Spell
    SpellBad = { sp = colors.red, undercurl = true },
    SpellCap = { sp = colors.orange_main, undercurl = true },
    SpellLocal = { sp = colors.orange_deep, undercurl = true },
    SpellRare = { sp = colors.orange_bright, undercurl = true },

    -- LSP Diagnostics
    DiagnosticError = { fg = colors.red },
    DiagnosticWarn = { fg = colors.orange_main },
    DiagnosticInfo = { fg = colors.orange_deep },
    DiagnosticHint = { fg = colors.brown_light },
    DiagnosticUnderlineError = { sp = colors.red, undercurl = true },
    DiagnosticUnderlineWarn = { sp = colors.orange_main, undercurl = true },
    DiagnosticUnderlineInfo = { sp = colors.orange_deep, undercurl = true },
    DiagnosticUnderlineHint = { sp = colors.brown_light, undercurl = true },

    -- Treesitter
    ["@variable"] = { fg = colors.brown_dark },
    ["@variable.builtin"] = { fg = colors.brown_deepest },
    ["@function"] = { fg = colors.brown_darker },
    ["@function.builtin"] = { fg = colors.brown_deepest },
    ["@method"] = { fg = colors.brown_darker },
    ["@constructor"] = { fg = colors.brown_light },
    ["@keyword"] = { fg = colors.brown_medium },
    ["@keyword.function"] = { fg = colors.brown_medium },
    ["@keyword.return"] = { fg = colors.brown_medium },
    ["@type"] = { fg = colors.brown_light },
    ["@type.builtin"] = { fg = colors.brown_light },
    ["@namespace"] = { fg = colors.brown_light },
    ["@property"] = { fg = colors.brown_dark },
    ["@field"] = { fg = colors.brown_dark },
    ["@parameter"] = { fg = colors.brown_dark },
    ["@constant"] = { fg = colors.orange_warm },
    ["@constant.builtin"] = { fg = colors.orange_warm },
    ["@string"] = { fg = colors.orange_medium },
    ["@number"] = { fg = colors.orange_warm },
    ["@boolean"] = { fg = colors.orange_warm },
    ["@operator"] = { fg = colors.orange_main },
    ["@punctuation"] = { fg = colors.orange_deep },
    ["@comment"] = { fg = colors.brown_comment, italic = true },
    ["@tag"] = { fg = colors.orange_main },
    ["@tag.attribute"] = { fg = colors.brown_dark },
    ["@tag.delimiter"] = { fg = colors.orange_deep },

    -- Git
    GitSignsAdd = { fg = colors.orange_warm },
    GitSignsChange = { fg = colors.orange_main },
    GitSignsDelete = { fg = colors.red },

    -- Telescope
    TelescopeNormal = { fg = colors.fg, bg = colors.bg_dark },
    TelescopeBorder = { fg = colors.brown_muted, bg = colors.bg_dark },
    TelescopePromptNormal = { fg = colors.fg, bg = colors.bg_selection },
    TelescopePromptBorder = { fg = colors.orange_deep, bg = colors.bg_selection },
    TelescopePromptTitle = { fg = colors.orange_main, bold = true },
    TelescopePreviewTitle = { fg = colors.orange_deep, bold = true },
    TelescopeResultsTitle = { fg = colors.brown_light, bold = true },
    TelescopeSelection = { bg = colors.bg_selection },
    TelescopeMatching = { fg = colors.orange_bright, bold = true },

    -- NvimTree
    NvimTreeNormal = { fg = colors.fg, bg = colors.bg_dark },
    NvimTreeFolderName = { fg = colors.brown_light },
    NvimTreeFolderIcon = { fg = colors.brown_light },
    NvimTreeOpenedFolderName = { fg = colors.orange_main },
    NvimTreeSpecialFile = { fg = colors.orange_bright },
    NvimTreeExecFile = { fg = colors.orange_warm },
    NvimTreeGitDirty = { fg = colors.orange_main },
    NvimTreeGitNew = { fg = colors.orange_warm },
    NvimTreeGitDeleted = { fg = colors.red },

    -- Which-key
    WhichKey = { fg = colors.orange_main },
    WhichKeyGroup = { fg = colors.brown_light },
    WhichKeyDesc = { fg = colors.fg },
    WhichKeySeperator = { fg = colors.brown_comment },
    WhichKeyFloat = { bg = colors.bg_dark },

    -- Dashboard/Alpha
    DashboardShortCut = { fg = colors.orange_main },
    DashboardHeader = { fg = colors.orange_bright },
    DashboardCenter = { fg = colors.brown_light },
    DashboardFooter = { fg = colors.brown_comment },
  }

  -- Apply all highlights
  for group, settings in pairs(highlights) do
    vim.api.nvim_set_hl(0, group, settings)
  end
end

-- Load function for use with :colorscheme
function M.load()
  M.setup()
end

return M
