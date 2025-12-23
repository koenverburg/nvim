local config = require("core.config")

local actions = require("telescope.actions")
local builtin = require("telescope.builtin")
local devicons = require("nvim-web-devicons")
local search = require("search")

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
pcall(require("telescope").load_extension, "ast_grep")
pcall(require("telescope").load_extension, "ui-select")

-- pcall(require("telescope").load_extension, "live_grep_args")

-- local live_grep_args = require("telescope.extensions.live_grep_args")

-- pcall(require("telescope").load_extension, "smart_history")

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
vim.keymap.set("n", "<space>fb", function()
  builtin.buffers(dropdown(false, 0.5, 0.5))
end)
vim.keymap.set("n", "<space>/", builtin.current_buffer_fuzzy_find)

vim.keymap.set("n", "<space>gw", builtin.grep_string)

-- Define a custom finder function for only *.widget.ts files
local filtered_search = function(topic)
  -- Arguments passed to the external `rg` command
  local custom_rg_args = {
    "rg",
    "--color=never",
    "--no-heading",
    "--with-filename",
    "--line-number",
    "--column",
    "--smart-case",
    "--glob", -- Use glob flag to include only these files
    topic,
  }

  -- Call the built-in live_grep function with our custom arguments
  builtin.live_grep({
    vimgrep_arguments = custom_rg_args,
    prompt_title = "Grep *.widget.ts files",
    -- Optional: customize keymaps within the picker
    mappings = {
      i = {
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-j>"] = actions.move_selection_next,
        ["<CR>"] = actions.select_default,
      },
    },
  })
end

-- Map this function to a key combination (e.g., <leader>sw)
vim.keymap.set("n", "<leader>sw", function()
  return filtered_search("*payments*")
end, { desc = "Built-in Grep only *payments* files" })

local find_widget_files = function()
  -- This command uses 'fd' (or 'rg --files' if 'fd' isn't present)
  -- to list only files matching the glob pattern.
  local find_cmd = {
    "fd",
    ".", -- Search starting from the current directory
    "--type",
    "f", -- Only list files
    "--glob", -- Enable glob matching
    "*.widget.tsx", -- The pattern to include
  }

  -- If you don't have 'fd' but do have 'ripgrep' (rg):
  -- local find_cmd = {
  --     'rg',
  --     '--files',
  --     '--glob',
  --     '*.widget.ts',
  -- }

  builtin.find_files({
    prompt_title = "Find *.widget.ts files",
    find_command = find_cmd,
    -- You can still type in the prompt to fuzzy filter these results
  })
end

-- Map this function to a key combination (e.g., <leader>fw for Find Widgets)
vim.keymap.set("n", "<leader>fw", find_widget_files, { desc = "Find only *.widget.ts files" })

-- local grep_widgets = function(topic)
--   -- The arguments passed to ripgrep (rg)
--   local rg_args = {
--     "rg",
--     "--color=never",
--     "--no-heading",
--     "--with-filename",
--     "--line-number",
--     "--column",
--     "--smart-case",
--     "--glob", -- use --glob flag
--     topic,
--   }
--
--   live_grep_args.live_grep_args({
--     vimgrep_arguments = rg_args,
--   })
-- end
--
-- search.setup({
--   -- Mappings to switch between tabs (like pressing Tab in JetBrains popup)
--   mappings = {
--     next = { { "<Tab>", "n" }, { "<Tab>", "i" } },
--     prev = { { "<S-Tab>", "n" }, { "<S-Tab>", "i" } },
--   },
--   -- Define the tabs to emulate JetBrains scopes
--   tabs = {
--     -- "All" scope can be a general file search or a custom function
--     { name = "Files", tele_func = builtin.find_files },
--     -- "Text" scope (Find in Files/Live Grep)
--     { name = "Grep", tele_func = builtin.live_grep },
--     -- "Classes" scope (requires LSP for robust functionality)
--     { name = "Classes", tele_func = builtin.lsp_workspace_symbols, tele_opts = { symbol_scope = "class" } },
--     -- "Symbols" scope (methods, fields, etc.)
--     { name = "Symbols", tele_func = builtin.lsp_workspace_symbols },
--     -- "Actions" scope (IDE commands)
--     { name = "Payments", tele_func = grep_widgets("payments") },
--   },
--   -- Optional: set initial tab by index or name
--   initial_tab = 1,
-- })
--
-- -- Define a keymap to open the integrated search panel (e.g., mapped to <leader>ss or <leader><leader> like JetBrains)
-- vim.keymap.set("n", "<leader>ss", function()
--   search.open({ layout_config = { width = 0.8, height = 0.4 } }) -- Customize the size of the popup
-- end, { desc = "Open Tabbed Search Panel (Search Everywhere)" })
