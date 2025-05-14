require("globals")

return {
  "stevearc/overseer.nvim",
  enabled = Is_enabled("overseer"),
  event = LoadOnBuffer,
  opts = {
    task_list = {
      direction = "float",
    },
    -- Floating window config
    form = {
      border = "rounded",
    },
    -- Auto actions
    templates = { "builtin" },
  },
  config = function(_, opts)
    local overseer = require("overseer")
    overseer.setup(opts)

    local is_windows = vim.loop.os_uname().sysname == "Windows_NT"
    local shell_cmd = is_windows and { "cmd.exe", "/C" } or { "sh", "-c" }

    local function command_template(name, raw_cmd)
      return {
        name = name,
        builder = function()
          -- Expand % to absolute file path
          local expanded_cmd = raw_cmd:gsub("%%", vim.fn.expand("%:p"))
          return {
            cmd = vim.tbl_flatten({ shell_cmd, expanded_cmd }),
            components = {
              "default",
              {
                "on_complete_notify",
                statuses = { "FAILURE" },
                only_once = true,
              },
              {
                "on_complete_dispose",
                statuses = { "SUCCESS" },
              },
              {
                "on_output_quickfix",
                open = false,
              },
            },
          }
        end,
      }
    end

    -- Define your commands here
    local commands = {
      command_template("GenK8s", "bun run ./deploy/generate/index.ts"),
      -- command_template("Format", "prettier --write %"),
      -- command_template("Lint", "eslint %"),
      -- command_template("Build", "tsc"),
    }

    -- Register the templates
    for _, template in ipairs(commands) do
      overseer.register_template(template)
    end

    -- Keymaps
    -- local function bind_run(name, key)
    --   vim.keymap.set("n", key, function()
    --     overseer.run_template({ name = name }, function(task)
    --       if task then overseer.open({ direction = "float" }) end
    --     end)
    --   end, { desc = "Run " .. name })
    -- end
    --
    -- bind_run("Format", "<leader>cf")
    -- bind_run("Lint", "<leader>cl")
    -- bind_run("Build", "<leader>cb")
  end,
}
