-- Set this up for ollama and adi github copilot

return {
  "yetone/avante.nvim",
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  -- ⚠️ must add this setting! ! !
  build = vim.fn.has("win32") ~= 0 and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
    or "make",
  event = "VeryLazy",
  enabled = false,
  version = false, -- Never set this value to "*"! Never!
  ---@module 'avante'
  ---@type avante.Config
  opts = {
    -- add any opts here
    -- this file can contain specific instructions for your project
    -- instructions_file = "avante.md",
    -- for example
    provider = "ollama",
    providers = {
      ollama = {
        ["local"] = true,
        endpoint = "127.0.0.1:11434/v1",
        model = "deepseek-r1:14b",
        parse_response_data = function(data_stream, event_state, opts)
          require("avante.providers").copilot.parse_response(data_stream, event_state, opts)
        end,
        parse_curl_args = function(opts, code_opts)
          return {
            url = opts.endpoint .. "/chat/completions",
            headers = {
              ["Accept"] = "application/json",
              ["Content-Type"] = "application/json",
            },
            body = {
              model = opts.model,
              messages = require("avante.providers").copilot.parse_messages(code_opts), -- you can make your own message, but this is very advanced
              max_tokens = 2048,
              stream = true,
            },
          }
        end,
      },
    },
    shortcuts = {
      {
        name = "refactor",
        description = "Refactor code with best practices",
        details = "Automatically refactor code to improve readability, maintainability, and follow best practices while preserving functionality",
        prompt = "Please refactor this code following best practices, improving readability and maintainability while preserving functionality.",
      },
      {
        name = "test",
        description = "Generate unit tests",
        details = "Create comprehensive unit tests covering edge cases, error scenarios, and various input conditions",
        prompt = "Please generate comprehensive unit tests for this code, covering edge cases and error scenarios.",
      },
      -- Add more custom shortcuts...
    },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    --- The below dependencies are optional,
    "nvim-mini/mini.pick", -- for file_selector provider mini.pick
    "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
    "ibhagwan/fzf-lua", -- for file_selector provider fzf
    "stevearc/dressing.nvim", -- for input provider dressing
    "folke/snacks.nvim", -- for input provider snacks
    "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
    "zbirenbaum/copilot.lua", -- for providers='copilot'
    {
      -- support for image pasting
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        -- recommended settings
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          -- required for Windows users
          use_absolute_path = true,
        },
      },
    },
    {
      -- Make sure to set this up properly if you have lazy=true
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
}
