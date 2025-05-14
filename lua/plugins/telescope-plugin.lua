require("globals")
local devicons = require("nvim-web-devicons")
local funcs = require("core.functions")
local math = require("math")
local ts_settings = require("settings.telescope")
-- local leaderfui = require("settings.telescope-leaderf")

return {
  "nvim-telescope/telescope.nvim",
  enabled = Is_enabled("telescope"),
  lazy = false,
  dependencies = {
    "nvim-lua/popup.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      enabled = Is_enabled("telescope"),
      lazy = false,
      build = "make",
    },
  },
  config = function()
    local telescope = require("telescope")

    telescope.setup({
      defaults = ts_settings.default,
      extensions = {
        fzf = {
          fuzzy = false, -- false will only do exact matching
          override_file_sorter = true, -- override the file sorter
          override_generic_sorter = true, -- override the generic sorter
          case_mode = "ignore_case", -- or "ignore_case" or "respect_case", the default case_mode is "smart_case"
        },
        ["ui-select"] = {
          require("telescope.themes").get_dropdown({
            layout_config = {
              prompt_position = "top",
              width = function(_, max_columns, _)
                return math.min(max_columns, 80)
              end,
              height = function(_, _, max_lines)
                return math.min(max_lines, 15)
              end,
            },
          }),
        },
      },
    })

    telescope.load_extension("fzf")
    telescope.load_extension("ui-select")
    telescope.load_extension("possession")

    local themes = require("telescope.themes")
    local pickers = require("telescope.pickers")
    local actions = require("telescope.actions")
    local finders = require("telescope.finders")
    local conf = require("telescope.config").values
    local make_entry = require("telescope.make_entry")
    local action_state = require("telescope.actions.state")

    -- region
    funcs.telescope_map("<space>fg", function()
      local opts = ts_settings.standard_search()
      require("telescope.builtin").live_grep(opts)
    end)

    funcs.telescope_map("<space>t", function()
      local opts = ts_settings.standard()
      require("telescope.builtin").git_files(opts)
    end)

    local function git_files_dropdown()
      local opts = ts_settings.dropdown(false, 0.6, 0.8)
      require("telescope.builtin").git_files(opts)
    end
    funcs.telescope_map("<space>p", git_files_dropdown)

    -- blazing fast current word searching
    funcs.telescope_map("<space>cs", function()
      local cword = vim.fn.expand("<cword>")
      local opts = ts_settings.standard_search({
        search = cword,
      })
      require("telescope.builtin").grep_string(opts)
    end)

    funcs.telescope_map("<space>fd", function()
      local opts = ts_settings.standard_search({
        previewer = false,
        results_title = false,
      })

      -- local opts = themes.get_cursor({
      --  previewer = false
      -- })

      require("telescope.builtin").diagnostics(opts)
    end)

    funcs.telescope_map("<space>ff", function()
      local opts = ts_settings.standard({
        find_command = {
          "rg",
          "--ignore",
          "--hidden",
          "--files",
        },
      })
      require("telescope.builtin").find_files(opts)
    end)

    funcs.telescope_map("<space>b", function()
      local opts = themes.get_dropdown({
        previewer = false,
        layout_strategy = "center",
        sorting_strategy = "ascending",
        layout_config = {
          width = 0.5,
          height = 0.3,
          prompt_position = "top",
        },
        entry_maker = ts_settings.gen_from_buffer_like_leaderf(),
        attach_mappings = function(prompt_bufnr, map)
          local delete_buf = function()
            local selection = action_state.get_selected_entry()
            actions.close(prompt_bufnr)
            vim.api.nvim_buf_delete(selection.bufnr, { force = true })
          end
          -- map("i", "d", delete_buf)
          return true
        end,
      })
      require("telescope.builtin").buffers(opts)
    end)

    funcs.telescope_map("<space>gs", function()
      local function string_grep_proxy(value)
        local opts = ts_settings.standard_search({
          search = value,
        })
        require("telescope.builtin").grep_string(opts)
      end

      funcs.inputOrUI({
        -- default = "",
        prompt = "Grep String ",
      }, string_grep_proxy)
    end)

    local function lsp_references()
      local opts = ts_settings.standard_search()
      require("telescope.builtin").lsp_references(opts)
    end

    local function lsp_document_symbols()
      local opts = ts_settings.standard_search()
      require("telescope.builtin").lsp_document_symbols(opts)
    end

    if Is_enabled("telescope") and Is_enabled("lsp") then
      funcs.telescope_map("<leader>cx", "lsp_code_actions")
      funcs.telescope_map("<c-r>", lsp_references)
      -- funcs.telescope_map("<c-d>", lsp_document_symbols) -- turned off in favor of namu
    end

    local function filter_with_treesitter(symbol)
      return function()
        local opts = ts_settings.standard_search({
          symbols = symbol,
        })
        require("telescope.builtin").treesitter(opts)
      end
    end

    -- endregion
    funcs.telescope_map("<space><space>", function()
      local Menu = require("nui.menu")
      local event = require("nui.utils.autocmd").event

      local overseer = require("overseer")
      -- local tasks = require("overseer").list_tasks()
      -- print(vim.inspect(tasks))

      local menu = Menu({
        relative = "cursor",
        position = {
          row = 1,
          col = 0,
        },
        size = {
          width = 20,
          height = 10,
        },
        border = {
          style = "rounded",
          text = {
            top = "",
            top_align = "center",
          },
        },
        win_options = {
          winhighlight = "Normal:Normal,FloatBorder:Normal",
        },
      }, {
        lines = {
          -- stylua: ignore start
          Menu.item("Git Files",              { func = git_files_dropdown }),
          Menu.item("tree query (functions)", { func = filter_with_treesitter({ "function", "var" }) }),
          Menu.item("tree query",             { func = filter_with_treesitter() }),

          Menu.item("namu - symbols (jump)",    { cmd = "Namu symbols" }),
          Menu.item("namu - watchtower (jump)", { cmd = "Namu watchtower" }),
          Menu.item("namu - diagnostics ",      { cmd = "Namu diagnostics" }),
          Menu.item("namu - call",              { cmd = "Namu call both" }),

          Menu.item("lsp - references",  { func = lsp_references }),
          Menu.item("lsp - definitions", { func = lsp_document_symbols }),

          Menu.item("OS - run GenK8s", { task = "GenK8s" }),
          -- stylua: ignore end
        },
        max_width = 25,
        keymap = {
          focus_next = { "j", "<Down>", "<Tab>" },
          focus_prev = { "k", "<Up>", "<S-Tab>" },
          close = { "<Esc>" },
          submit = { "<CR>", "<Space>" },
        },
        on_close = function() end,
        on_submit = function(item)
          if item.func then
            item.func()
            return
          end

          if item.cmd then
            vim.cmd(item.cmd)
            return
          end

          if item.task then
            overseer.run_template({ name = item.name }, function(task)
              if task then
                overseer.open({ direction = "float" })
              end
            end)
          end
        end,
      })

      menu:mount()

      menu:on(event.BufLeave, function()
        menu:unmount()
      end)
    end)
  end,
}
