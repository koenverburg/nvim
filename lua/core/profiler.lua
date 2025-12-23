-- Enhanced profiler with startup timing
local M = {}

-- Track startup times
local startup_times = {}
local startup_start = vim.loop.hrtime()

function M.start_timer(name)
  startup_times[name] = vim.loop.hrtime()
end

function M.end_timer(name)
  if startup_times[name] then
    local duration = (vim.loop.hrtime() - startup_times[name]) / 1e6
    print(string.format("%s: %.2fms", name, duration))
    return duration
  end
  return 0
end

function M.profile_startup()
  if vim.env.PROF then
    local start_time = startup_start

    vim.defer_fn(function()
      local total_time = (vim.loop.hrtime() - start_time) / 1e6
      print(string.format("📊 Total startup time: %.2fms", total_time))

      -- Print plugin load times if available
      if package.loaded["lazy"] then
        print("🔌 Plugin load times:")
        local lazy = require("lazy")
        if lazy.stats then
          local stats = lazy.stats()
          print(string.format("  - Loaded: %d plugins", stats.loaded))
          print(string.format("  - Load time: %.2fms", stats.startuptime))
        end
      end

      -- Show memory usage
      local mem_kb = vim.fn.getpid() and vim.fn.system("ps -o rss= -p " .. vim.fn.getpid()) or "unknown"
      if mem_kb ~= "unknown" then
        mem_kb = tonumber(mem_kb:match("%d+"))
        if mem_kb then
          print(string.format("💾 Memory usage: %.1fMB", mem_kb / 1024))
        end
      end
    end, 100)
  end
end

-- Initialize profiling if enabled
if vim.env.PROF then
  -- example for lazy.nvim
  -- change this to the correct path for your plugin manager
  local snacks = vim.fn.stdpath("data") .. "/lazy/snacks.nvim"
  vim.opt.rtp:append(snacks)
  require("snacks.profiler").startup({
    startup = {
      -- event = "VimEnter", -- stop profiler on this event. Defaults to `VimEnter`
      event = "UIEnter",
      -- event = "VeryLazy",
    },
  })

  -- Add our custom profiling
  M.profile_startup()
end

-- Expose as vim command
vim.api.nvim_create_user_command("ProfileStartup", function()
  M.profile_startup()
end, { desc = "Show startup profiling information" })

return M
