local config = require("core.config")
local devicons = require("nvim-web-devicons")

local data = assert(vim.fn.stdpath("data")) --[[@as string]]
local default_icons, _ = devicons.get_icon("file", "", { default = true })

local ok, themes = pcall(require, "telescope.themes")

if not ok then
  return
end
-- local entry_display = require("telescope.pickers.entry_display")

local ui = {
  box = "■",
  plus = "+",
  topleft = "┏",
  topright = "┓",
  bottomleft = "┗",
  bottomright = "┛",
  line_horizontal = "─",
  line_vertical = "│",
  rightTee = "⊢",
  leftTee = "⊣",
}

local borderchars_dropdown = {
  prompt = { "─", "│", "─", "│", "╭", "╮", ui.plus, ui.plus },
  results = { "─", "│", "─", "│", "├", "┤", "╯", "╰" },
  preview = { "─", "│", "─", "│", ui.plus, ui.plus, ui.plus, ui.plus },
}

-- local function custom_entry_maker()
--   local displayer = entry_display.create({
--     separator = " ",
--     items = {
--       { width = vim.fn.strwidth(default_icons) },
--       { remaining = true },
--       { remaining = true },
--     },
--   })
--
--   local make_display = function(entry)
--     return displayer({
--       { entry.devicons, entry.devicons_highlight },
--       entry.file_name,
--       { entry.dir_name, "Comment" },
--     })
--   end
--
--   return function(entry, _)
--     local file_name = vim.fn.fnamemodify(entry, ":p:t")
--     local dir_name = vim.fn.fnamemodify(entry, "%:p:h")
--     dir_name = string.gsub(dir_name, "/" .. file_name, "")
--
--     local icons, highlight = devicons.get_icon(entry, string.match(entry, "%a+$"), { default = true })
--
--     return {
--       value = entry,
--
--       display = make_display,
--       ordinal = entry,
--
--       devicons = icons,
--       devicons_highlight = highlight,
--
--       file_name = file_name,
--       dir_name = dir_name,
--     }
--   end
-- end

local function dropdown(previewer, width, height)
  return themes.get_dropdown({
    show_untracked = true,
    results_title = false,
    previewer = previewer,

    sorting_strategy = "ascending",
    -- entry_maker = custom_entry_maker(),

    layout_strategy = "center",

    layout_config = {
      width = width,
      height = height,
    },

    borderchars = borderchars_dropdown,
  })
end

local simple_layout = {
  hidden = true,
  no_ignore = true,
  previewer = false,

  show_untracked = true,
  results_title = false,
}

require("telescope").setup({
  defaults = {
    color_devicons = true,
    sorting_strategy = "ascending",

    selection_caret = config.signs.caret .. " ",
    prompt_prefix = " " .. config.signs.telescope .. " ",

    -- entry_maker = custom_entry_maker(),

    borderchars = {
      prompt = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
      results = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
      preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    },

    layout_config = {
      width = 0.9,
      height = 0.75,
      prompt_position = "top",
    },
  },
  extensions = {
    wrap_results = true,

    fzf = {
      fuzzy = false, -- false will only do exact matching
      override_file_sorter = true, -- override the file sorter
      override_generic_sorter = true, -- override the generic sorter
      case_mode = "ignore_case", -- or "ignore_case" or "respect_case", the default case_mode is "smart_case"
    },

    -- history = {
    --   path = vim.fs.joinpath(data, "telescope_history.sqlite3"),
    --   limit = 100,
    -- },

    ["ui-select"] = {
      require("telescope.themes").get_dropdown(),
    },
  },
})

pcall(require("telescope").load_extension, "fzf")
pcall(require("telescope").load_extension, "ui-select")
-- pcall(require("telescope").load_extension, "smart_history")

local builtin = require("telescope.builtin")

vim.keymap.set("n", "<space>ff", builtin.find_files)

vim.keymap.set("n", "<space>t", function()
  return builtin.git_files()
end)
vim.keymap.set("n", "<space>p", function()
  return builtin.git_files(dropdown(false, 0.6, 0.8))
end)
vim.keymap.set("n", "<c-p>", function()
  return builtin.git_files(dropdown(false, 0.6, 0.8))
end)

vim.keymap.set("n", "<space>fh", builtin.help_tags)
-- vim.keymap.set("n", "<space>fb", builtin.buffers(dropdown(false, 0.6, 0.8)))
vim.keymap.set("n", "<space>/", builtin.current_buffer_fuzzy_find)

vim.keymap.set("n", "<space>gw", builtin.grep_string)
vim.keymap.set("n", "<space>gs", require("custom.telescope.multi-ripgrep"))
