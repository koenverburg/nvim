local isUbuntu = string.find(vim.loop.os_gethostname(), "mars") ~= nil
local isWorkLaptop = string.find(vim.loop.os_gethostname(), "AMS") ~= nil
local isPersonalLaptop = not isUbuntu and not isWorkLaptop

local core = {
  env = {
    isUbuntu,
    isWorkLaptop,
    isPersonalLaptop,
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

  diagnosticSigns = {
    { color = "DiagnosticSignInfo", icon = "" },
    { color = "DiagnosticSignHint", icon = "" },
    { color = "DiagnosticSignWarn", icon = "" },
    { color = "DiagnosticSignError", icon = "" },
  },

  colors = {
    yellow = "#FFCC00",
    gray = "#888888",
    black = "#111111",
  },

  supported_languages = {
    "lua",
    -- "javascript",
    -- "javascriptreact",
    "typescript",
    "typescriptreact",
    "tsx",
  },
}

return core
