local IsUbuntu = string.find(vim.loop.os_gethostname(), "mars") ~= nil
local core = {
  env = {
    isWorkLaptop = string.find(vim.loop.os_gethostname(), "AMS") ~= nil,
  },

  chars = {
    lines = {
      horizontal = {
        light = "─",
        heavy = "━",
        dashed = "╌",
        alt1 = "╴",
        alt2 = "╸",
      },
    },
  },

  -- #region signs
  signs = {
    info = "",
    hint = "",
    warn = "",
    error = "",
    git = "",
    searchProject = "󰺅",
    searchFiles = "󰱽",
    searchText = "󱎸",
    notebook = "",
    recentfiles = "󱋢",
    cog = "",
    org = "",
    checkmark = "",
    rightArrow = "",
    smallRightArrow = "",
    guillemet = "»",
    close = "",
    gitAdd = "|",
    gitDelete = "_",
    gitTopDelete = "‾",
    gitChangeDelete = "~",
    gitUntracked = "┆",
    telescope = "",
    caret = ">",
    cmd = "",
    lightning = "",
    document = "",
    import = "",
    keyboard = "",
    sleep = "󰒲",
    filledOrb = "●",
    orb = "○",
    package = "󰏗",
    vim = "",
    code = "",
    play = "",
    star = "",
    line = "‒",
    ignored = "",
    unstaged = "",
    staged = "",
    conflict = "",
    ellipsis = "…",
  },
  -- #endregion signs

  -- #region icons
  icons = {
    Class = "",
    Constructor = "",
    Function = "󰊕",
    Keyword = "",
    Method = "",
    Module = "",
    Field = "",
    Snippet = "󰘖",
    Text = "",
    Variable = "",
  },
  -- #endregion icons

  diagnosticSigns = {
    { color = "DiagnosticSignInfo", icon = "" },
    { color = "DiagnosticSignHint", icon = "" },
    { color = "DiagnosticSignWarn", icon = "" },
    { color = "DiagnosticSignError", icon = "" },
  },

  colors = {
    yellow = "#FFCC00",
    gray = "#888888",
    black = "#111111",
  },

  lsp_servers = {},

  treesitter_grammers = {},

  supported_languages = {
    "lua",
    -- "javascript",
    -- "javascriptreact",
    "typescript",
    "typescriptreact",
    "tsx",
  },

  -- #region plugins
  plugins = {
    -- stylua: ignore start
    -- Core Functionality - Enabled
    ["autoclose"]         = { enabled = true },
    ["blink-cmp"]         = { enabled = true },
    ["comment"]           = { enabled = true },
    ["conform"]           = { enabled = true },
    ["debugprint"]        = { enabled = true },
    ["easy-align"]        = { enabled = true },
    ["git"]               = { enabled = true },
    ["lsp"]               = { enabled = true },
    ["goto-preview"]      = { enabled = true },
    ["nvim-bqf"]          = { enabled = true },
    ["nvim-surround"]     = { enabled = true },
    ["pretty-fold"]       = { enabled = false },
    ["smart-splits"]      = { enabled = true },
    ["symbol-usage"]      = { enabled = true },
    ["treesitter"]        = { enabled = true },
    ["visual-whitespace"] = { enabled = true },
    ["treesj"]            = { enabled = true },

    -- Core Functionality - Disabled
    ["lsp-snippets"]    = { enabled = false },

    -- Tests
    ["nvim-coverage"]    = { enabled = true },

    -- Navigation & Movement - Enabled
    ["hop"]             = { enabled = true },
    ["nvim-tree"]       = { enabled = true },
    ["telescope"]       = { enabled = true },
    ["namu"]            = { enabled = true },

    -- Navigation & Movement - Disabled
    ["nvim-spider"]     = { enabled = false },
    ["vim-maximizer"]   = { enabled = false },

    -- ENV tooling - Enabled
    ["cloak"]           = { enabled = true },

    -- UI Enhancement - Enabled
    ["lualine"]          = { enabled = true },
    ["hydra"]            = { enabled = true },
    ["mini-hipatterns"]  = { enabled = true },
    ["neocolumn"]        = { enabled = true },
    ["noice"]            = { enabled = true },
    ["nvim-toggler"]     = { enabled = true },
    ["incline"]          = { enabled = true },
    ["colorful-menu"]    = { enabled = true },
    ["commentless"]      = { enabled = true },
    ["no-neck-pain"]     = { enabled = true },
    ["indent-blankline"] = { enabled = false },

    -- UI Enhancement - Disabled
    ["bionic"]           = { enabled = false },
    ["precognition"]     = { enabled = false },
    ["sunglasses"]       = { enabled = false },

    -- Colorschemes - Enabled
    ["no-clown-fiesta"] = { enabled = true },
    ["gruvbox"]         = { enabled = false },
    ["evergarden"]      = { enabled = false },
    ["neomodern"]       = { enabled = false },

    -- AI/Advanced
    ["avante"]          = { enabled = false },

    -- Personal
    ["personal/minimal-tabline"] = { enabled = true },
    ["personal/peepsight"]       = { enabled = true },
    ["personal/cmd-palette"]     = { enabled = true },

    ["personal/complexity"]      = { enabled = false },
    ["personal/static"]          = { enabled = true },

    ["personal/nightcoder"]      = { enabled = false },
    -- stylua: ignore end
  },
  -- #endregion
}

return core
