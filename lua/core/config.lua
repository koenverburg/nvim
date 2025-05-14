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
    ["autopair"]          = { enabled = true },
    ["blink-cmp"]         = { enabled = true },
    ["comment"]           = { enabled = true },
    ["conform"]           = { enabled = true },
    ["debugprint"]        = { enabled = true },
    ["easy-align"]        = { enabled = true },
    ["git"]               = { enabled = true },
    ["lsp"]               = { enabled = true },
    ["nvim-bqf"]          = { enabled = true },
    ["nvim-surround"]     = { enabled = true },
    ["pretty-fold"]       = { enabled = true },
    ["smart-splits"]      = { enabled = true },
    ["symbol-usage"]      = { enabled = true },
    ["treesitter"]        = { enabled = true },
    ["visual-whitespace"] = { enabled = true },

    -- Core Functionality - Disabled
    ["lsp-snippets"]    = { enabled = false },
    ["pretty-hovers"]   = { enabled = false },
    ["lualine"]         = { enabled = false },

    -- Navigation & Movement - Enabled
    ["hop"]             = { enabled = true },
    ["minimal-tabline"] = { enabled = true },
    ["nvim-tree"]       = { enabled = true },
    ["telescope"]       = { enabled = true },
    ["namu"]            = { enabled = true },

    -- Navigation & Movement - Disabled
    ["nvim-spider"]     = { enabled = false },
    ["vim-maximizer"]   = { enabled = false },

    -- ENV tooling - Enabled
    ["cloak"]           = { enabled = true },

    -- UI Enhancement - Enabled
    ["cmd-palette"]     = { enabled = true },
    ["hydra"]           = { enabled = true },
    ["mini-hipatterns"] = { enabled = true },
    ["neocolumn"]       = { enabled = true },
    ["noice"]           = { enabled = true },
    ["nvim-toggler"]    = { enabled = true },
    ["peepsight"]       = { enabled = true },
    ["possession"]      = { enabled = true }, -- update this one.
    ["incline"]         = { enabled = true },
    ["colorful-menu"]   = { enabled = true },

    -- UI Enhancement - Disabled
    ["bionic"]          = { enabled = false },
    ["complexity"]      = { enabled = false },
    ["precognition"]    = { enabled = false },
    ["static"]          = { enabled = false },
    ["sunglasses"]      = { enabled = false },

    -- Colorschemes - Enabled
    ["no-clown-fiesta"] = { enabled = true },

    -- Colorschemes - Disabled
    ["evergarden"]      = { enabled = false },
    ["gruvbox"]         = { enabled = false },
    ["neomodern"]       = { enabled = false },
    ["nightcoder"]      = { enabled = false },

    -- AI/Advanced
    ["avante"]          = { enabled = true },
    ["overseer"]        = { enabled = true },

    -- stylua: ignore end
  },
  -- #endregion
}

return core
