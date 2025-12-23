local prefix = "<space>t"

local function find_root(path)
  -- local root = path:match("(.-/[^/]+/)src")
  -- if root then
  --   return root
  -- end

  -- root = path:match("(.-/(projects)/[^/]+)") or path:match("(.-/(apps)/[^/]+)") or path:match("(.-/(libs)/[^/]+)")

  -- if root then
  --   return root
  -- end

  return vim.fn.getcwd()
end

local function get_absolute_path(path)
  return vim.fn.fnamemodify(path, ":p")
end

local function get_project_root(file_path)
  return M.get_absolute_path(find_root(file_path))
end

local function current_project_root()
  return M.get_project_root(vim.fn.expand("%"))
end

return {
  "nvim-neotest/neotest",
  lazy = false,
  enabled = true,
  event = LoadOnBuffer,
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "nvim-neotest/neotest-jest",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    local neotest = require("neotest")
    local neotestJest = require("neotest-jest")
    local jestUtil = require("neotest-jest.jest-util")

    local setup_complete = false

    vim.diagnostic.config({ virtual_text = true })

    local function possibly_init()
      if setup_complete then
        return
      end
      local adapters = {}

      -- Load neotest-jest conditionally
      if vim.bo.filetype == "typescript" or vim.bo.filetype == "typescriptreact" then
        table.insert(
          adapters,
          neotestJest({
            jestCommand = jestUtil.getJestCommand(vim.fn.expand("%:p:h")),
            cwd = function()
              return vim.fs.dirname(vim.fn.expand("%"))
            end,
          })
        )
      end

      -- table.insert(adapters, require("neotest-gradle"))
      -- table.insert(adapters, require("neotest-rust"))

      neotest.setup({
        log_level = vim.log.levels.DEBUG,
        floating = {
          border = "rounded",
          max_height = 100,
          max_width = 100,
          options = {},
        },
        adapters = adapters,
      })
      setup_complete = true
    end

    local function test_nearest()
      possibly_init()
      neotest.run.run({ suite = false })
      neotest.summary.open()
    end

    local function watch_tests()
      possibly_init()
      neotest.watch.watch({
        suite = false,
      })
      neotest.summary.open()
    end

    vim.keymap.set("n", prefix .. "n", test_nearest, { desc = "[T]est [N]earest" })
    -- vim.keymap.set("n", "<leader>tw", watch_tests, { desc = "[T]est [W]atch" })

    -- require("neotest").setup({
    --   adapters = {
    --     require("neotest-jest")({
    --       jestCommand = "node --expose-gc --no-compilation-cache ./node_modules/jest/bin/jest.js",
    --       jestConfigFile = function (path) return get_project_root(path) .. "/frontend/jest.common.json" end,
    --       env = { CI = true },
    --       cwd = function(path)
    --         return get_project_root(path)
    --       end,
    --     }),
    --   },
    --   output = {
    --     enabled = true,
    --     open_on_run = "short",
    --   },
    --   quickfix = {
    --     open = false,
    --     enabled = true,
    --   },
    --   status = {
    --     signs = true,
    --     enabled = true,
    --     virtual_text = true,
    --   },
    --   icons = {
    --     passed = "✓",
    --     running = "●",
    --     failed = "✗",
    --     skipped = "○",
    --     unknown = "?",
    --   },
    -- })
    -- {
    --   adapters = {
    --     require("neotest-jest")({
    --       jestCommand = "node --expose-gc --no-compilation-cache ./node_modules/jest/bin/jest.js",
    --       jestConfigFile = "frontend/jest.common.json",
    --       env = { CI = true },
    --       cwd = function()
    --         return vim.fn.getcwd()
    --       end,
    --     }),
    --   },
    --   -- Optional: customize output and diagnostic settings
    --   output = {
    --     enabled = true,
    --     open_on_run = "short",
    --   },
    --   quickfix = {
    --     open = false,
    --     enabled = true,
    --   },
    --   status = {
    --     signs = true,
    --     enabled = true,
    --     virtual_text = true,
    --   },
    --   icons = {
    --     passed = "✓",
    --     running = "●",
    --     failed = "✗",
    --     skipped = "○",
    --     unknown = "?",
    --   },
    -- })
  end,
  keys = {
    -- {
    --   prefix .. "n",
    --   function()
    --     require("neotest").run.run()
    --   end,
    --   desc = "Run nearest test",
    -- },
    {
      prefix .. "f",
      function()
        require("neotest").run.run(vim.fn.expand("%"))
      end,
      desc = "Run current test file",
    },
    {
      prefix .. "a",
      function()
        require("neotest").run.run(vim.fn.getcwd())
      end,
      desc = "Run all tests",
    },
    {
      prefix .. "d",
      function()
        require("neotest").run.run({ strategy = "dap" })
      end,
      desc = "Debug nearest test",
    },
    {
      prefix .. "s",
      function()
        require("neotest").run.stop()
      end,
      desc = "Stop nearest test",
    },
    {
      prefix .. "S",
      function()
        require("neotest").summary.toggle()
      end,
      desc = "Toggle test summary",
    },
    {
      prefix .. "o",
      function()
        require("neotest").output.open({ enter = true, auto_close = true })
      end,
      desc = "Show test output",
    },
    {
      prefix .. "O",
      function()
        require("neotest").output_panel.toggle()
      end,
      desc = "Toggle output panel",
    },
    {
      "[t",
      function()
        require("neotest").jump.prev({ status = "failed" })
      end,
      desc = "Jump to previous failed test",
    },
    {
      "]t",
      function()
        require("neotest").jump.next({ status = "failed" })
      end,
      desc = "Jump to next failed test",
    },
    {
      prefix .. "w",
      function()
        require("neotest").watch.toggle()
      end,
      desc = "Toggle watch nearest test",
    },
    {
      prefix .. "W",
      function()
        require("neotest").watch.toggle(vim.fn.expand("%"))
      end,
      desc = "Toggle watch current file",
    },
  },
}
