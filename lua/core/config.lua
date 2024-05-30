local core = {
  env = {
    isWorkLaptop = string.find(vim.loop.os_gethostname(), "AMS") ~= nil,
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
    { color = "DiagnosticSignWarn", icon = "" },
    { color = "DiagnosticSignError", icon = "" },
  },

  colors = {
    yellow = "#FFCC00",
    black = "#888888",
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
    -- stylua: ignore-start
    ["git"] = { enabled = true },
    ["lsp"] = { enabled = true },
    ["lsp-snippets"] = { enabled = true },
    ["lualine"] = { enabled = true },
    ["treesitter"] = { enabled = true },
    ["telescope"] = { enabled = true },
    ["mini-hipatterns"] = { enabled = true },
    ["nvim-toggler"] = { enabled = true },
    ["hop"] = { enabled = true },
    ["possession"] = { enabled = true },
    ["comment"] = { enabled = true },
    ["nvim-tree"] = { enabled = true },
    ["autopair"] = { enabled = true },
    ["neocolumn"] = { enabled = true },
    ["hydra"] = { enabled = true },
    ["noice"] = { enabled = true },
    ["pretty-fold"] = { enabled = true },
    ["conform"] = { enabled = true },
    ["easy-align"] = { enabled = true },
    ["harpeek"] = { enabled = true },
    ["smart-splits"] = { enabled = true },
    ["nvim-bqf"] = { enabled = true },
    ["sunglasses"] = { enabled = true },
    ["cloak"] = { enabled = true },
    ["calltree"] = { enabled = true },
    ["debugprint"] = { enabled = true },
    ["bionic"] = { enabled = false },
    ["nvim-spider"] = { enabled = false },
    ["visual-whitespace"] = { enabled = true },
    ["nvim-surround"] = { enabled = true },
    ["symbol-usage"] = { enabled = true },
    ["pretty-hovers"] = { enabled = false },
    ["precognition"] = { enabled = false },
    -- colorscheme
    ["borrowed"] = { enabled = true },
    ["rose-pine"] = { enabled = false },
    ["auto-theme"] = { enabled = false },
    ["no-clown-fiesta"] = { enabled = false },
    -- My Plugins
    ["static"] = { enabled = true },
    ["complexity"] = { enabled = true },
    ["peepsight"] = { enabled = true },
    ["cmd-palette"] = { enabled = true },
    ["minimal-tabline"] = { enabled = true },

    -- stylua: ignore end

    -- ["accelerated-jk"]          = { enabled = true },
    -- ["auto-colorscheme"]        = { enabled = false },
    -- ["centerpad"]               = { enabled = true },
    -- ["cmd-palette"]             = { enabled = true },
    -- ["cokeline"]                = { enabled = true },
    -- ["colorizer"]               = { enabled = false },
    -- ["comment"]                 = { enabled = true },
    -- ["cursorword"]              = { enabled = true },
    -- ["darcula"]                 = { enabled = false },
    -- ["dashboard"]               = { enabled = true },
    -- ["deadcolumn.nvim"]         = { enabled = false },
    -- ["eyeliner"]                = { enabled = true },
    -- ["formatting"]              = { enabled = true },
    -- ["gen"]                     = { enabled = false },
    -- ["git"]                     = { enabled = true },
    -- ["github"]                  = { enabled = false },
    -- ["gruvbox"]                 = { enabled = false },
    -- ["hop"]                     = { enabled = true }, -- move
    -- ["hydra"]                   = { enabled = true }, -- move
    -- ["icons"]                   = { enabled = true },
    -- ["indent-blankline"]        = { enabled = true },
    -- ["leap"]                    = { enabled = false },
    -- ["lsp"]                     = { enabled = true },
    -- ["lsp-formatting"]          = { enabled = true },
    -- ["lsp-snippets"]            = { enabled = true },
    -- ["mini-hipatterns"]         = { enabled = true },
    -- ["minimal-statusline"]      = { enabled = false },
    -- ["fork-whiskyline"]         = { enabled = true },
    -- ["minimal-tabline"]         = { enabled = true },
    -- ["misc"]                    = { enabled = true },
    -- ["mulicursors"]            = { enabled = false },
    -- ["nebulous"]                = { enabled = false },
    -- ["nightcoder"]              = { enabled = false },
    -- ["no-clown-fiesta"]         = { enabled = false },
    -- ["default-no-clown-fiesta"] = { enabled = true },
    -- ["noice"]                   = { enabled = true },
    -- ["nvim-navbuddy"]           = { enabled = false }, -- should use more
    -- ["nvim-tree"]               = { enabled = true },
    -- ["nvim-window"]             = { enabled = true },
    -- ["peepsight"]               = { enabled = true },
    -- ["persistence"]             = { enabled = false },
    -- ["possession"]              = { enabled = true },
    -- ["pretty-fold"]             = { enabled = true },
    -- ["refactoring"]             = { enabled = true },
    -- ["search"]                  = { enabled = true },
    -- ["session"]                 = { enabled = false },
    -- ["solarized"]               = { enabled = false },
    -- ["static"]                  = { enabled = true },
    -- ["surround"]                = { enabled = true },
    -- ["tabtree"]                 = { enabled = true },
    -- ["telescope"]               = { enabled = true },
    -- ["template"]                = { enabled = false },
    -- ["themery"]                 = { enabled = false },
    -- ["tint"]                    = { enabled = false },
    -- ["tmux"]                    = { enabled = true },
    -- ["toggleterm"]              = { enabled = false },
    -- ["treesitter"]              = { enabled = true },
    -- ["treesj"]                  = { enabled = true },
    -- ["ts-node-action"]          = { enabled = true },
  },
  -- #endregion
}

return core
