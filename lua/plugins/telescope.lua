require("globals")
local config = require("core.config")

local funcs = require("core.functions")
local ts_settings = require("settings.telescope")
-- local leaderfui = require("settings.telescope-leaderf")

local function find_files_or_git_files()
  if vim.loop.fs_stat(vim.loop.cwd() .. "/.git") then
    local opts = ts_settings.dropdown(false, 0.6, 0.8)
    require("telescope.builtin").git_files(opts)
  else
    local opts = {
      hidden = true,
      no_ignore = true,
      previewer = false,
    }

    require("telescope.builtin").find_files(opts)
  end
end

local defaults = {
  color_devicons = true,
  sorting_strategy = "ascending",

  selection_caret = config.signs.caret .. " ",
  prompt_prefix = " " .. config.signs.telescope .. " ",

  -- borderchars = M.borderchars_boldcorner,
  borderchars = {
    prompt = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    results = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
  },

  layout_config = {
    height = 0.75,
    width = 0.9,
  },
}

return {
  "nvim-telescope/telescope.nvim",
  enabled = Is_enabled("telescope"),
  lazy = true,
  event = LoadOnBuffer,
  -- cmd = {
  --   "Telescope"
  -- },
  keys = {
    "<space>ff",
    "<space>t",
    "<space>p",
    "<space>gs",
    "<c-p>",
  },
  dependencies = {
    "nvim-lua/popup.nvim",
    "nvim-lua/plenary.nvim",

    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-telescope/telescope-smart-history.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
    "kkharji/sqlite.lua",
  },
  config = function()
    require("plugin-configs.telescope")
    -- local telescope = require("telescope")
    --
    -- telescope.setup({
    --   defaults = ts_settings.default,
    --   extensions = {
    --     fzf = {
    --       fuzzy = false, -- false will only do exact matching
    --       override_file_sorter = true, -- override the file sorter
    --       override_generic_sorter = true, -- override the generic sorter
    --       case_mode = "ignore_case", -- or "ignore_case" or "respect_case", the default case_mode is "smart_case"
    --     },
    --     history = {
    --       path = vim.fs.joinpath(data, "telescope_history.sqlite3"),
    --       limit = 100,
    --     },
    --     ["ui-select"] = {
    --       require("telescope.themes").get_dropdown {},
    --     },
    --     -- ["ui-select"] = {
    --     --   require("telescope.themes").get_dropdown({
    --     --     layout_config = {
    --     --       prompt_position = "top",
    --     --       width = function(_, max_columns, _)
    --     --         return math.min(max_columns, 80)
    --     --       end,
    --     --       height = function(_, _, max_lines)
    --     --         return math.min(max_lines, 15)
    --     --       end,
    --     --     },
    --     --   }),
    --     -- },
    --   },
    -- })
    --
    -- telescope.load_extension("fzf")
    -- telescope.load_extension("ui-select")
    -- telescope.load_extension("smart_history")
    --
    -- local themes = require("telescope.themes")
    -- local pickers = require("telescope.pickers")
    -- local actions = require("telescope.actions")
    -- local finders = require("telescope.finders")
    -- local conf = require("telescope.config").values
    -- local make_entry = require("telescope.make_entry")
    -- local action_state = require("telescope.actions.state")
    --
    -- -- region
    -- funcs.telescope_map("<space>fg", function()
    --   local opts = ts_settings.standard_search()
    --   require("telescope.builtin").live_grep(opts)
    -- end)
    --
    -- funcs.telescope_map("<space>t", function()
    --   local opts = ts_settings.standard()
    --   require("telescope.builtin").git_files(opts)
    -- end)
    --
    -- local function git_files_dropdown()
    --   local opts = ts_settings.dropdown(false, 0.6, 0.8)
    --   require("telescope.builtin").git_files(opts)
    -- end
    -- funcs.telescope_map("<space>p", git_files_dropdown)
    --
    -- -- blazing fast current word searching
    -- funcs.telescope_map("<space>cs", function()
    --   local cword = vim.fn.expand("<cword>")
    --   local opts = ts_settings.standard_search({
    --     search = cword,
    --   })
    --   require("telescope.builtin").grep_string(opts)
    -- end)
    --
    -- funcs.telescope_map("<space>fd", function()
    --   local opts = ts_settings.standard_search({
    --     previewer = false,
    --     results_title = false,
    --   })
    --
    --   -- local opts = themes.get_cursor({
    --   --  previewer = false
    --   -- })
    --
    --   require("telescope.builtin").diagnostics(opts)
    -- end)
    --
    -- funcs.telescope_map("<space>ff", function()
    --   local opts = ts_settings.standard({
    --     find_command = {
    --       "rg",
    --       "--ignore",
    --       "--hidden",
    --       "--files",
    --     },
    --   })
    --   require("telescope.builtin").find_files(opts)
    -- end)
    --
    -- funcs.telescope_map("<space>b", function()
    --   local opts = themes.get_dropdown({
    --     previewer = false,
    --     layout_strategy = "center",
    --     sorting_strategy = "ascending",
    --     layout_config = {
    --       width = 0.5,
    --       height = 0.3,
    --       prompt_position = "top",
    --     },
    --     borderchars = ts_settings.borderchars_borderbox,
    --     entry_maker = ts_settings.gen_from_buffer_like_leaderf(),
    --     attach_mappings = function(prompt_bufnr, map)
    --       local delete_buf = function()
    --         local selection = action_state.get_selected_entry()
    --         actions.close(prompt_bufnr)
    --         vim.api.nvim_buf_delete(selection.bufnr, { force = true })
    --       end
    --       -- map("i", "d", delete_buf)
    --       return true
    --     end,
    --   })
    --   require("telescope.builtin").buffers(opts)
    -- end)
    --
    -- funcs.telescope_map("<space>gs", function()
    --   local function string_grep_proxy(value)
    --     local opts = ts_settings.standard_search({
    --       search = value,
    --     })
    --     require("telescope.builtin").grep_string(opts)
    --   end
    --
    --   funcs.inputOrUI({
    --     -- default = "",
    --     prompt = "Grep String ",
    --   }, string_grep_proxy)
    -- end)
    --
    -- local function lsp_references()
    --   local opts = ts_settings.standard_search()
    --   require("telescope.builtin").lsp_references(opts)
    -- end
    --
    -- if Is_enabled("telescope") and Is_enabled("lsp") then
    --   funcs.telescope_map("<leader>cx", "lsp_code_actions")
    --   funcs.telescope_map("<c-r>", lsp_references)
    --   -- funcs.telescope_map("<c-d>", lsp_document_symbols) -- turned off in favor of namu
    -- end
    --
    -- funcs.telescope_map("<leader>f", find_files_or_git_files)
    --
    -- endregion
  end,
}
