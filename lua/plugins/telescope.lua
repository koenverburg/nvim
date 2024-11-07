require("globals")
local funcs = require("core.functions")
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
    local ts = require("telescope")

    ts.setup({
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
              width = 0.6,
              height = 0.6,
              prompt_position = "top",
            },
          }),
        },
      },
    })

    ts.load_extension("fzf")
    ts.load_extension("ui-select")
    ts.load_extension("possession")

    local themes = require("telescope.themes")
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")

    funcs.telescope_map("<space>ff", function()
      local opts = {
        layout_strategy = "horizontal",
        layout_config = {
          prompt_position = "top",
        },
        find_command = {
          "rg",
          "--ignore",
          "--hidden",
          "--files",
        },
      }
      require("telescope.builtin").find_files(opts)
    end)

    funcs.telescope_map("<space>t", function()
      local opts = {
        prompt_prefix = "",
        results_title = false,
        layout_config = ts_settings.wide("top").layout_config,
      }
      require("telescope.builtin").git_files(opts)
    end)

    local simple_git = function()
      local opts = themes.get_dropdown({
        prompt_prefix = "",
        results_title = false,

        previewer = false,
        layout_strategy = "center",
        sorting_strategy = "ascending",

        -- entry_maker = leaderfui.gen_from_buffer_like_leaderf(),

        layout_config = ts_settings.small_dropdown("top").layout_config,
      })
      require("telescope.builtin").git_files(opts)
    end

    funcs.telescope_map("<space>p", simple_git)
    funcs.telescope_map("<c-p>", simple_git)

    funcs.telescope_map("<space><space>", function()
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
      local input = {
        prompt = "Grep String ",
        default = "",
      }

      local function string_grep_proxy(value)
        local opts = {
          search = value,
          layout_strategy = "horizontal",
          layout_config = ts_settings.wide("top").layout_config,
        }

        require("telescope.builtin").grep_string(opts)
      end

      funcs.inputOrUI(input, string_grep_proxy)
    end)

    -- blazing fast current word searching
    funcs.telescope_map("<space>cs", function()
      local cword = vim.fn.expand("<cword>")

      local opts = {
        search = cword,
        layout_strategy = "horizontal",
        layout_config = ts_settings.wide("top").layout_config,
      }

      require("telescope.builtin").grep_string(opts)
    end)

    funcs.telescope_map("<space>fg", function()
      local opts = {
        -- shorten_path = false,
        -- scroll_strategy = 'cycle',
        -- sorting_strategy = 'descending',
        layout_strategy = "horizontal",
        layout_config = ts_settings.wide("top").layout_config,
      }

      require("telescope.builtin").live_grep(opts)
    end)

    funcs.telescope_map("<space>sn", function()
      local opts = {
        previewer = false,
        prompt_title = "~ Notes ~",
        cwd = "~/code/github/obsidian",
        layout_strategy = "vertical",
        layout_config = {
          prompt_position = "top",
        },
      }

      require("telescope.builtin").git_files(opts)
    end)

    funcs.telescope_map("<space>ed", function()
      local opts = {
        prompt_title = "~ Dotfiles ~",
        cwd = "~/code/github/dotfiles",
        -- previewer = true,
        layout_strategy = "horizontal",
        layout_config = {
          prompt_position = "top",
        },
      }

      require("telescope.builtin").git_files(opts)
    end)

    funcs.telescope_map("<space>fd", function()
      local opts = {
        prompt_prefix = "",
        results_title = false,
        previewer = false,
        layout_config = ts_settings.wide("top").layout_config,
      }
      require("telescope.builtin").diagnostics(opts)
    end)

    if Is_enabled("telescope") and Is_enabled("lsp") then
      -- local themes = require "telescope.themes"

      funcs.telescope_map("<c-r>", function()
        local opts = {
          previewer = true,
          layout_config = ts_settings.wide("top").layout_config,
        }
        require("telescope.builtin").lsp_references(opts)
      end)

      funcs.telescope_map("<c-d>", function()
        local opts = {
          previewer = true,
          layout_config = ts_settings.wide("top").layout_config,
        }
        require("telescope.builtin").lsp_document_symbols(opts)
      end)

      funcs.telescope_map("<leader>cx", "lsp_code_actions")
    end
  end,
}
