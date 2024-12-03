local config = require("core.config")
local devicons = require("nvim-web-devicons")
local M = {}

local default_icons, _ = devicons.get_icon("file", "", { default = true })

M.default = {
  color_devicons = true,
  sorting_strategy = "ascending",
  selection_caret = config.signs.caret .. " ",
  prompt_prefix = " " .. config.signs.telescope .. " ",
  borderchars = {
    prompt = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    results = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
  },
  layout_config = {
    height = 0.75,
    width = 0.9,
  },
  -- mappings = {
  --   i = {
  --     ["<CR>"] = select_one_or_multi,
  --   },
  -- },
}

local select_one_or_multi = function(prompt_bufnr)
  local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
  local multi = picker:get_multi_selection()
  if not vim.tbl_isempty(multi) then
    require("telescope.actions").close(prompt_bufnr)
    for _, j in pairs(multi) do
      if j.path ~= nil then
        vim.cmd(string.format("%s %s", "edit", j.path))
      end
    end
  else
    require("telescope.actions").select_default(prompt_bufnr)
  end
end

function M.custom_entry_maker()
  local entry_display = require("telescope.pickers.entry_display")
  local displayer = entry_display.create({
    separator = " ",
    items = {
      { width = vim.fn.strwidth(default_icons) },
      { remaining = true },
      { remaining = true },
    },
  })

  local make_display = function(entry)
    return displayer({
      { entry.devicons, entry.devicons_highlight },
      entry.file_name,
      { entry.dir_name, "Comment" },
    })
  end

 return function (entry, k)
    local file_name = vim.fn.fnamemodify(entry, ":p:t")
    local dir_name = vim.fn.fnamemodify(entry, "%:p:h")
    dir_name = string.gsub(dir_name, "/" .. file_name, "")

    local icons, highlight = devicons.get_icon(entry, string.match(entry, "%a+$"), { default = true })

    return {
      value = entry,

      display = make_display, 
      ordinal = entry,

      devicons = icons,
      devicons_highlight = highlight,

      file_name = file_name,
      dir_name = dir_name,
    }
  end
end

function M.wide(position)
  return {
    layout_config = {
      prompt_position = position,
      height = function(_, _, max_lines)
        return math.floor(max_lines * 0.95)
      end,
    },
  }
end

function M.small_dropdown(position)
  return {
    layout_config = {
      width = 0.6,
      height = 0.6,
      prompt_position = position,
    },
  }
end

local filter = vim.tbl_filter
local map = vim.tbl_map

function M.gen_from_buffer_like_leaderf(opts)
  local entry_display = require("telescope.pickers.entry_display")
  opts = opts or {}
  local default_icons, _ = devicons.get_icon("file", "", { default = true })

  local bufnrs = filter(function(b)
    return 1 == vim.fn.buflisted(b)
  end, vim.api.nvim_list_bufs())

  local max_bufnr = math.max(unpack(bufnrs))
  local bufnr_width = #tostring(max_bufnr)

  local max_bufname = math.max(unpack(map(function(bufnr)
    return vim.fn.strdisplaywidth(vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":p:t"))
  end, bufnrs)))

  local displayer = entry_display.create({
    separator = " ",
    items = {
      -- { width = bufnr_width },
      -- { width = 4 },
      { width = vim.fn.strwidth(default_icons) },
      { width = max_bufname },
      { remaining = true },
    },
  })

  local make_display = function(entry)
    return displayer({
      -- { entry.bufnr, "TelescopeResultsNumber" },
      -- { entry.indicator, "TelescopeResultsComment" },
      { entry.devicons, entry.devicons_highlight },
      entry.file_name,
      { entry.dir_name, "Comment" },
    })
  end

  return function(entry)
    local bufname = entry.info.name ~= "" and entry.info.name or "[No Name]"
    local hidden = entry.info.hidden == 1 and "h" or "a"
    local readonly = vim.api.nvim_buf_get_option(entry.bufnr, "readonly") and "=" or " "
    local changed = entry.info.changed == 1 and "+" or " "
    local indicator = entry.flag .. hidden .. readonly .. changed

    local dir_name = vim.fn.fnamemodify(bufname, ":p:h")
    local file_name = vim.fn.fnamemodify(bufname, ":p:t")

    local icons, highlight = devicons.get_icon(bufname, string.match(bufname, "%a+$"), { default = true })

    return {
      valid = true,

      value = bufname,
      ordinal = entry.bufnr .. " : " .. file_name,
      display = make_display,

      bufnr = entry.bufnr,

      lnum = entry.info.lnum ~= 0 and entry.info.lnum or 1,
      indicator = indicator,
      devicons = icons,
      devicons_highlight = highlight,

      file_name = file_name,
      dir_name = dir_name,
    }
  end
end

local function mergeDictionaries(t1, t2)
  for key, value in pairs(t2) do
    t1[key] = value
  end
  return t1
end

-- local opts = ts_settings.dropdown(true, 0.6, 0.6)
function M.dropdown(previewer, width, height)
  local themes = require("telescope.themes")

  return themes.get_dropdown({
    results_title = false,
    previewer = previewer,

    sorting_strategy = "ascending",
    entry_maker = M.custom_entry_maker(),

    layout_strategy = "center",

    layout_config = {
      width = width,
      height = height,
    },
  })
end

function M.standard(opts)
  opts = opts or {}
  local themes = require("telescope.themes")

  local defaults = {
    sorting_strategy = "ascending",
    entry_maker = M.custom_entry_maker(),
    layout_strategy = "horizontal",

    layout_config = {
      width = 0.9,
      height = 0.9,
      preview_width = 0.6,
      prompt_position = "top"
    }
  }

  return mergeDictionaries(defaults, opts) 
end

function M.standard_search(opts)
  opts = opts or {}
  -- local themes = require("telescope.themes")

  local defaults = {
    sorting_strategy = "ascending",
    layout_strategy = "horizontal",
    layout_config = {
      width = 0.9,
      height = 0.9,
      preview_width = 0.6,
      prompt_position = "top"
    }
  }
  return mergeDictionaries(defaults, opts) 
end

return M
