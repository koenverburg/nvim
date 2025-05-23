local p = require("custom.lines.provider")
local utils = require("core.utils")
local signs = require("core.config").signs

local opts = {
  ["ignore-filetypes"] = {
    "help",
    "startify",
    "dashboard",
    "packer",
    "NvimTree",
    "Trouble",
    "alpha",
    "Outline",
    "lazy",
  },
  events = {
    "CursorMoved",
    "CursorHold",
    "BufWinEnter",
    "BufEnter",
    "BufFilePost",
    "InsertEnter",
    "BufWritePost",
    "TabClosed",
  },
}

local function is_nil(val)
  return ((val == nil) or (val == ""))
end

local function ignore()
  return vim.tbl_contains(opts["ignore-filetypes"], p.get_filetype())
end

-- local dark = "#1d1d1f" --- "#FB467B" -- "#151515"
local text = "#ffffff"
local dark = "#afafaf"

vim.api.nvim_set_hl(0, "SectionSL_A", { bg = dark })
vim.api.nvim_set_hl(0, "SectionSL_B", { fg = dark })
vim.api.nvim_set_hl(0, "SectionSL_C", { bg = dark, fg = "#121212" })

local function wrap_start(v, left, right)
  -- local l = ""
  local l = " "
  -- local r = " "
  return "%#SectionSL_A#" .. v .. "%#SectionSL_B#" .. l .. "%#Normal#"
end

local function wrap_section_left(v)
  if v == nil or v == "" then
    return ""
  end

  -- local l = ""
  local l = " "
  local ll = " "
  -- local r = " "
  return "%#SectionSL_C#" .. ll .. "%#SectionSL_A#" .. v .. "%#SectionSL_B#" .. l .. "%#Normal#"
end

local function wrap_section_right(v)
  if v == nil or v == "" then
    return ""
  end

  local r = " "
  return "%#SectionSL_B#" .. r .. "%#SectionSL_A#" .. v .. "%#SectionSL_C#" .. r .. "%#Normal#"
end

local function wrap_start_right(v)
  local r = " "

  if v == nil or v == "" then
    return "%#SectionSL_B#" .. r .. "%#SectionSL_A#" .. " " .. "%#Normal#"
  end

  return "%#SectionSL_B#" .. r .. "%#SectionSL_A#" .. v .. " " .. "%#Normal#"
end

local cache = {}
local function refresh_cache(key)
  if cache[key] then
    cache[key].value = cache[key].fn()
  end
end
local function cache_get(key, compute_fn)
  local cached = cache[key]

  if cached then
    return cached.value
  end

  local value = compute_fn()

  if utils.isNotEmpty(value) then
    cache[key] = { value = value, fn = compute_fn }
  end

  return value or ""
end

local function smart_file_path()
  return cache_get("file_path", function()
    local buf_name = vim.api.nvim_buf_get_name(0)
    local is_wide = vim.api.nvim_win_get_width(0) > 80

    if buf_name == "" then
      return "[No Name]"
    end

    local file_name = vim.fn.fnamemodify(buf_name, ":t")
    local with_dir_name = vim.fn.fnamemodify(buf_name, ":.")

    if is_wide then
      return with_dir_name
    end

    return file_name
  end)
end

local function word_count()
  local words = vim.fn.wordcount()
  if words.visual_words ~= nil then
    return string.format("[%s]", words.visual_words)
  else
    return string.format("[%s]", words.words)
  end
end

local modes = setmetatable({
  ["n"] = { "NORMAL", "N" },
  ["no"] = { "N·OPERATOR", "N·P" },
  ["nov"] = { "O·PENDING", "O·P" },
  ["noV"] = { "O·PENDING", "O·P" },
  ["no\22"] = { "O·PENDING", "O·P" },
  ["niI"] = { "NORMAL", "N" },
  ["niR"] = { "NORMAL", "N" },
  ["niV"] = { "NORMAL", "N" },
  ["nt"] = { "NORMAL", "N" },
  ["ntT"] = { "NORMAL", "N" },
  ["v"] = { "VISUAL", "V" },
  ["V"] = { "V·LINE", "V·L" },
  ["\22"] = { "V·BLOCK", "V·B" },
  ["\22s"] = { "V·BLOCK", "V·B" },
  ["s"] = { "SELECT", "S" },
  ["S"] = { "S·LINE", "S·L" },
  ["\19"] = { "S·BLOCK", "S·B" },
  ["i"] = { "INSERT", "I" },
  ["ic"] = { "INSERT", "I" },
  ["ix"] = { "INSERT", "I" },
  ["R"] = { "REPLACE", "R" },
  ["Rv"] = { "V·REPLACE", "V·R" },
  ["Rc"] = { "REPLACE", "R" },
  ["Rx"] = { "REPLACE", "R" },
  ["Rvc"] = { "V·REPLACE", "V·R" },
  ["Rvx"] = { "V·REPLACE", "V·R" },
  ["c"] = { "COMMAND", "C" },
  ["cv"] = { "VIM·EX", "V·E" },
  ["ce"] = { "EX", "E" },
  ["r"] = { "PROMPT", "P" },
  ["rm"] = { "MORE", "M" },
  ["r?"] = { "CONFIRM", "C" },
  ["!"] = { "SHELL", "S" },
  ["t"] = { "TERMINAL", "T" },
}, {
  __index = function()
    return { "UNKNOWN", "U" } -- handle edge cases
  end,
})

local function get_current_mode()
  local mode = modes[vim.api.nvim_get_mode().mode]
  local result = string.format(" %s", mode[1]) -- long name

  if vim.api.nvim_win_get_width(0) <= 80 then
    result = string.format(" %s", mode[2]) -- short name
  end

  return wrap_start(result)
end

local function get_icon_by_filetype(ft)
  if not ft then
    return ""
  end

  local ok, icons = pcall(require, "nvim-web-devicons")
  if not ok then
    return ""
  end

  local icon, color = icons.get_icon_by_filetype(ft)
  if not icon then
    return ""
  end

  return "%#" .. color .. "#" .. icon .. " " .. "%#Normal#"
end

local function file_type()
  return cache_get("file_type", function()
    local ft = vim.bo.filetype
    if ft == "" then
      return "[None]"
    else
      local icon = get_icon_by_filetype(ft)
      return icon -- .. ft
    end
  end)
end

local function branch()
  return cache_get("git_branch", function()
    if vim.g.gitsigns_head then
      return signs.git .. " " .. vim.g.gitsigns_head
    end
    return ""
  end)
end

local function formatters()
  return cache_get("formatters", function()
    return p.formatters()
    -- return " " .. p.formatters()
  end)
end

local function clients()
  return cache_get("clients", function()
    return p.active_clients()
  end)
end

---@diagnostic disable-next-line: lowercase-global
function status_line()
  if (ignore() ~= true) and (is_nil(p.get_filename()) == false) then
    return table.concat({
      "%#Normal#",
      get_current_mode(),
      wrap_section_left(branch()),
      wrap_section_left(smart_file_path()), -- smart full path filename
      file_type(),
      "%h%m%r%w", -- help flag, modified, readonly, and preview

      "%=", -- right align

      wrap_section_right(formatters()),
      wrap_start_right(clients()),

      -- " %<", -- spacing
      -- " %<", -- spacing
      --
      --
      -- status_for_file(), -- git status for file
      -- p.get_git_status(),

      -- word_count(), -- word count
      -- "[%-3.(%l|%c]", -- line number, column number
      -- spell_status(), -- display language and if spell is on
      -- human_file_size(), -- file size
    })
  end

  return "%#Normal#"
end

vim.api.nvim_create_augroup("StatusLineCache", {})
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  pattern = "*",
  group = "StatusLineCache",
  callback = function()
    refresh_cache("git_branch") -- this should be another event
    refresh_cache("git_status")
    refresh_cache("file_status")
    refresh_cache("file_size")
    refresh_cache("file_path")
    refresh_cache("file_type")
  end,
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  pattern = "*",
  group = "StatusLineCache",
  callback = function()
    refresh_cache("file_status")
    refresh_cache("file_size")
    refresh_cache("file_path")
  end,
})

vim.api.nvim_create_autocmd({ "LspAttach" }, {
  pattern = "*",
  group = "StatusLineCache",
  callback = function()
    refresh_cache("formatters")
    refresh_cache("clients")
  end,
})

vim.api.nvim_create_autocmd({ "WinResized" }, {
  pattern = "*",
  group = "StatusLineCache",
  callback = function()
    refresh_cache("git_branch")
    refresh_cache("file_path")
    refresh_cache("file_type")
  end,
})

vim.opt.statusline = "%!luaeval('status_line()')"
