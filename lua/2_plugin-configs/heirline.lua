-- local TabLine = require("plugin-configs.heirline-tabline").TabLine
local conditions = require("heirline.conditions")
local core = require("core.config")
local diagnostics_helpers = require("logic.diagnostic")
local git_helpers = require("logic.git")
local utils = require("heirline.utils")

local palette = require("no-clown-fiesta.palettes").get("dark")

local function hl(name)
  local ok, ret = pcall(utils.get_highlight, name)
  return ok and ret or {}
end

local theme = {
  bg = hl("StatusLine").bg or hl("Normal").bg,
  fg = hl("StatusLine").fg or hl("Normal").fg,

  hint = hl("DiagnosticHint").fg or hl("StatusLine").fg,
  info = hl("DiagnosticInfo").fg or hl("StatusLine").fg,
  error = hl("DiagnosticError").fg or hl("ErrorMsg").fg or "#e55561",
  warn = hl("DiagnosticWarn").fg or hl("WarningMsg").fg or "#e2b86b",

  red = hl("DiagnosticError").fg or hl("ErrorMsg").fg or "#e55561",
  yellow = hl("DiagnosticWarn").fg or hl("WarningMsg").fg or "#e2b86b",

  blue = hl("Function").fg or "#4aa5f0",
  cyan = hl("Special").fg or "#61d6d6",
  green = hl("String").fg or "#7ec699",
  orange = hl("Constant").fg or "#e19d5c",
  purple = hl("Statement").fg or "#c099ff",
  comment = hl("Comment").fg or "#666666",

  git = hl("DevIconGitLogo").fg or "#e55561",
  git_add = hl("GitSignsAdd").fg or "#98c379",
  git_del = hl("GitSignsDelete").fg or "#e06c75",
  git_change = hl("GitSignsChange").fg or "#61afef",
}

local ViMode = {
  init = function(self)
    self.mode = vim.fn.mode(1)
  end,
  static = {
    mode_names = {
      n = "Normal",
      no = "Operator Pending",
      nov = "Operator Pending",
      noV = "Operator Pending",
      ["no\22"] = "Operator Pending",
      niI = "Normal Insert",
      niR = "Normal Replace",
      niV = "Normal Visual",
      nt = "Normal Terminal",
      v = "Visual",
      vs = "Visual Select",
      V = "Visual Line",
      Vs = "Visual Select",
      ["\22"] = "Visual Block",
      ["\22s"] = "Visual Block Select",
      s = "Select",
      S = "Select Line",
      ["\19"] = "Select Block",
      i = "Insert",
      ic = "Insert Completion",
      ix = "Insert Completion",
      R = "Replace",
      Rc = "Replace Completion",
      Rx = "Replace Completion",
      Rv = "Virtual Replace",
      Rvc = "Virtual Replace Completion",
      Rvx = "Virtual Replace Completion",
      c = "Command",
      cv = "Ex Mode",
      r = "Prompt",
      rm = "More",
      ["r?"] = "Confirm",
      ["!"] = "Shell",
      t = "Terminal",
    },
    mode_colors = {
      n = palette.cursor_bg,
      i = palette.fg,
      v = palette.fg,
      V = palette.fg,
      ["\22"] = palette.fg,
      c = palette.fg,
      s = palette.fg,
      S = palette.fg,
      ["\19"] = palette.fg,
      R = palette.fg,
      r = palette.fg,
      ["!"] = palette.fg,
      t = palette.gray,
    },
  },
  provider = function(self)
    return " %2(" .. self.mode_names[self.mode] .. "%)"
  end,
  hl = function(self)
    local mode = self.mode:sub(1, 1)
    return {
      fg = self.mode_colors[mode],
      bold = true,
    }
    -- return { fg = theme.comment, bold = true, }
  end,
  update = {
    "ModeChanged",
    pattern = "*:*",
    callback = vim.schedule_wrap(function()
      vim.cmd("redrawstatus")
    end),
  },
}

local FileType = {
  provider = function()
    return string.upper(vim.bo.filetype)
  end,
  hl = "Type",
}

local FileNameBlock = {
  -- let's first set up some attributes needed by this component and its children
  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(0)
  end,
}
-- We can now define some children separately and add them later

local FileIcon = {
  init = function(self)
    local filename = self.filename
    local extension = vim.fn.fnamemodify(filename, ":e")
    self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
  end,
  provider = function(self)
    return self.icon and (" " .. self.icon .. " ")
  end,
  hl = function(self)
    return { fg = self.icon_color }
  end,
}

local FileName = {
  init = function(self)
    self.lfilename = vim.fn.fnamemodify(self.filename, ":.")
    if self.lfilename == "" then
      self.lfilename = "[No Name]"
    end
  end,
  hl = function()
    if vim.bo.modified then
      return { fg = utils.get_highlight("Directory").fg, bold = true, italic = true }
    end
    return "Directory"
  end,
  flexible = 3,
  {
    provider = function(self)
      return self.lfilename
    end,
  },
  {
    provider = function(self)
      return vim.fn.pathshorten(self.lfilename)
    end,
  },
  {
    provider = function(self)
      return vim.fn.expand("%:t")
    end,
  },
}

local FileFlags = {
  {
    condition = function()
      return vim.bo.modified
    end,
    provider = "[+]",
    hl = { fg = "green" },
  },
  {
    condition = function()
      return not vim.bo.modifiable or vim.bo.readonly
    end,
    provider = "",
    hl = { fg = theme.orange, bg = theme.bg },
  },
}

-- let's add the children to our FileNameBlock component
FileNameBlock = utils.insert(
  FileNameBlock,
  FileName,
  FileFlags,
  FileIcon,
  { provider = "%<" } -- this means that the statusline is cut here when there's not enough space
)

local LSPActive = {
  condition = conditions.lsp_attached,
  update = { "LspAttach", "LspDetach" },

  provider = function()
    local names = {}
    for _, server in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
      table.insert(names, server.name)
    end
    return "(" .. table.concat(names, " ") .. ")"
  end,

  hl = { fg = theme.comment },
}

local FormmattersActive = {
  condition = conditions.lsp_attached,

  update = { "LspAttach", "LspDetach" },

  provider = function()
    local names = {}
    local buf_ft = vim.bo.filetype

    -- conform.nvim (optional, comment this block if not using)
    local ok2, conform = pcall(require, "conform")
    if ok2 then
      local cfg = conform.formatters_by_ft[buf_ft] or {}
      for _, f in ipairs(cfg) do
        table.insert(names, type(f) == "string" and f or f.name)
      end
    end

    if vim.tbl_isempty(names) then
      return core.signs.orb
    end
    -- return core.signs.filledOrb .. " " .. table.concat(names, ", ")
    return "(" .. table.concat(names, ", ") .. ")"
  end,

  hl = { fg = theme.comment },
}

local Diagnostics = {
  condition = conditions.has_diagnostics,

  hl = { fg = theme.fg, bold = true },

  static = {
    error_icon = diagnostics_helpers.icons.error,
    warn_icon = diagnostics_helpers.icons.warn,
    info_icon = diagnostics_helpers.icons.info,
    hint_icon = diagnostics_helpers.icons.hint,
  },

  init = function(self)
    local stats = diagnostics_helpers.get_diagnostics_from_buffer(0)
    -- local stats = diagnostics_helpers.get_workspace_diagnostics()
    self.info = stats.info
    self.hints = stats.hints
    self.errors = stats.errors
    self.warnings = stats.warnings
  end,

  update = { "DiagnosticChanged", "BufEnter" },

  {
    provider = function(self)
      return self.errors > 0 and (self.error_icon .. " " .. self.errors .. " ")
    end,
    hl = { fg = theme.error },
  },
  {
    provider = function(self)
      return self.warnings > 0 and (self.warn_icon .. " " .. self.warnings .. " ")
    end,
    hl = { fg = theme.warn },
  },
  {
    provider = function(self)
      return self.info > 0 and (self.info_icon .. " " .. self.info .. " ")
    end,
    hl = { fg = theme.info },
  },
  {
    provider = function(self)
      return self.hints > 0 and (self.hint_icon .. " " .. self.hints)
    end,
    hl = { fg = theme.hints },
  },
}

local Git = {
  condition = conditions.is_git_repo,

  init = function(self)
    self.head = vim.b.gitsigns_status_dict and vim.b.gitsigns_status_dict.head or ""
    self.status = git_helpers.get_diff_from_buffer(0)
    self.has_changes = self.status.added ~= 0 or self.status.removed ~= 0 or self.status.changed ~= 0
  end,

  hl = { fg = theme.git },

  {
    provider = function(self)
      return " " .. self.head
    end,
    hl = { fg = theme.git, bold = true },
  },
  {
    condition = function(self)
      return self.has_changes
    end,
    provider = " (",
    hl = { fg = theme.git, bold = true },
  },
  {
    provider = function(self)
      local count = self.status.added or 0
      return count > 0 and (git_helpers.icons.added .. count)
    end,
    hl = { fg = theme.git_add },
  },
  {
    provider = function(self)
      local count = self.status.removed or 0
      return count > 0 and (git_helpers.icons.removed .. count)
    end,
    hl = { fg = theme.git_del },
  },
  {
    provider = function(self)
      local count = self.status.changed or 0
      return count > 0 and (git_helpers.icons.changed .. count)
    end,
    hl = { fg = theme.git_change },
  },
  {
    condition = function(self)
      return self.has_changes
    end,
    provider = ")",
    hl = { fg = theme.git, bold = true },
  },
}

local DAPMessages = {
  condition = function()
    local session = require("dap").session()
    return session ~= nil
  end,
  provider = function()
    return "%=  " .. require("dap").status()
  end,
  hl = "Debug",
}

local SearchCount = {
  condition = function()
    return vim.v.hlsearch ~= 0 and vim.o.cmdheight == 0
  end,
  init = function(self)
    local ok, search = pcall(vim.fn.searchcount)
    if ok and search.total then
      self.search = search
    end
  end,
  hl = { fg = theme.comment },
  provider = function(self)
    local search = self.search
    return string.format("(%d/%d)", search.current, math.min(search.total, search.maxcount))
  end,
}

local Spell = {
  condition = function()
    return vim.wo.spell
  end,
  provider = "SPELL ",
  hl = { bold = true, fg = "orange" },
}

local MacroRec = {
  condition = function()
    return vim.fn.reg_recording() ~= "" and vim.o.cmdheight == 0
  end,
  provider = " ",
  hl = { fg = "orange", bold = true },
  utils.surround({ "(", ")" }, nil, {
    provider = function()
      return vim.fn.reg_recording()
    end,
    hl = { fg = "green", bold = true },
  }),
  update = {
    "RecordingEnter",
    "RecordingLeave",
  },
}

local Align = { provider = "%=" }
local Space = { provider = " " }
local DefaultHL = { hl = { fg = theme.fg, bg = theme.bg } }

local StatusLine = {
  DefaultHL,
  ViMode,
  Space,
  Git,
  DAPMessages,
  Align,
  FileNameBlock,
  Align,
  Space,
  Spell,
  SearchCount,
  MacroRec,
  Diagnostics,
  Space,
  FormmattersActive,
  Space,
  LSPActive,
}

local InactiveStatusline = {
  condition = conditions.is_not_active,
  { hl = { fg = "gray", force = true } },
  FileNameBlock,
  { provider = "%<" },
  Align,
}

local HelpFilename = {
  condition = function()
    return vim.bo.filetype == "help"
  end,
  provider = function()
    local filename = vim.api.nvim_buf_get_name(0)
    return vim.fn.fnamemodify(filename, ":t")
  end,
  hl = "Directory",
}

local SpecialStatusline = {
  condition = function()
    return conditions.buffer_matches({
      buftype = { "nofile", "prompt", "help", "quickfix" },
      filetype = { "^git.*", "fugitive" },
    })
  end,
  Space,
  FileType,
  { provider = "%q" },
  Space,
  HelpFilename,
  Align,
}

local TerminalName = {
  {
    provider = function()
      local tname, _ = vim.api.nvim_buf_get_name(0):gsub(".*:", "")
      return " " .. tname
    end,
    hl = { fg = "blue", bold = true },
  },
  { provider = " - " },
  {
    provider = function()
      return vim.b.term_title
    end,
  },
}

local TerminalStatusline = {
  condition = function()
    return conditions.buffer_matches({ buftype = { "terminal" } })
  end,
  hl = { bg = "dark_red" },
  { condition = conditions.is_active, ViMode, Space },
  FileType,
  Space,
  TerminalName,
  Align,
}

local StatusLines = {
  hl = function()
    if conditions.is_active() then
      return "StatusLine"
    else
      return "StatusLineNC"
    end
  end,
  static = {
    mode_colors = {
      n = "red",
      i = "green",
      v = "cyan",
      V = "cyan",
      ["\22"] = "cyan", -- this is an actual ^V, type <C-v><C-v> in insert mode
      c = "orange",
      s = "purple",
      S = "purple",
      ["\19"] = "purple", -- this is an actual ^S, type <C-v><C-s> in insert mode
      R = "orange",
      r = "orange",
      ["!"] = "red",
      t = "green",
    },
    mode_color = function(self)
      local mode = conditions.is_active() and vim.fn.mode() or "n"
      return self.mode_colors[mode]
    end,
  },
  fallthrough = false,
  SpecialStatusline,
  TerminalStatusline,
  InactiveStatusline,
  StatusLine,
}

require("heirline").setup({
  -- tabline = TabLine,
  statusline = StatusLines,
  opts = { colors = theme },
})
