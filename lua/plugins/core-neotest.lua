local prefix = "<space>t"

return {
  "nvim-neotest/neotest",
  lazy = true,
  dependencies = {
    "nvim-neotest/nvim-nio",
    "arthur944/neotest-bun",
    "nvim-neotest/neotest-jest",
    "marilari88/neotest-vitest",
    "andythigpen/nvim-coverage",
    { "nvim-treesitter/nvim-treesitter", lazy = true },
  },

  config = function()
    local neotest = require("neotest")

    vim.diagnostic.config({ virtual_text = false })

    neotest.setup({
      log_level = vim.log.levels.INFO,

      floating = {
        border = "rounded",
        max_height = 100,
        max_width = 120,
      },

      adapters = {
        -------------------------
        -- Person projects
        -------------------------
        require("neotest-bun"),

        -------------------------
        -- Vitest (Bun) (new projects)
        -------------------------
        require("neotest-vitest")({
          vitestCommand = "bun vitest",
          filter_dir = function(name)
            return name ~= "node_modules"
          end,
        }),

        -------------------------
        -- Jest (legacy projectjs)
        -------------------------
        require("neotest-jest")({
          jestCommand = "bun test",
          cwd = function()
            return vim.fn.getcwd()
          end,
          env = { CI = true },
        }),
      },

      output = {
        open_on_run = false,
      },

      quickfix = {
        enabled = true,
        open = false,
      },

      summary = {
        enabled = true,
        follow = true,
      },
    })

    -- ======================
    -- Coverage setup
    -- ======================
    require("coverage").setup({
      auto_reload = true,
      commands = true,
      highlights = {
        covered = { fg = "#C3E88D" },
        uncovered = { fg = "#F07178" },
      },
      signs = {
        covered = { text = "▎" },
        uncovered = { text = "▎" },
      },
    })

    -- Auto-load coverage after test runs
    vim.api.nvim_create_autocmd("User", {
      pattern = "NeotestRunComplete",
      callback = function()
        require("coverage").load()
      end,
    })
  end,

  keys = {
    {
      prefix .. "n",
      function()
        require("neotest").run.run()
        require("neotest").summary.open()
      end,
      desc = "Test nearest",
    },
    {
      prefix .. "f",
      function()
        require("neotest").run.run(vim.fn.expand("%"))
      end,
      desc = "Test file",
    },
    {
      prefix .. "a",
      function()
        require("neotest").run.run(vim.fn.getcwd())
      end,
      desc = "Test all",
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
      desc = "Stop tests",
    },
    {
      prefix .. "S",
      function()
        require("neotest").summary.toggle()
      end,
      desc = "Toggle summary",
    },
    {
      prefix .. "o",
      function()
        require("neotest").output.open({ enter = true })
      end,
      desc = "Show output",
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
      desc = "Prev failed test",
    },
    {
      "]t",
      function()
        require("neotest").jump.next({ status = "failed" })
      end,
      desc = "Next failed test",
    },
    {
      prefix .. "w",
      function()
        require("neotest").watch.toggle()
      end,
      desc = "Watch nearest",
    },
    {
      prefix .. "W",
      function()
        require("neotest").watch.toggle(vim.fn.expand("%"))
      end,
      desc = "Watch file",
    },
    {
      prefix .. "c",
      "<cmd>CoverageLoad<CR>",
      desc = "Load coverage",
    },
    {
      prefix .. "C",
      "<cmd>CoverageClear<CR>",
      desc = "Clear coverage",
    },
  },
}
