-- lua/config/neotest.lua
-- Neotest for monorepo: checkout, ecom, bots
-- Adapters: Jest, Vitest, Bun test
-- Keymaps:
--   <leader>tc  run nearest (cursor)
--   <leader>tf  run current file
--   <leader>td  debug nearest (TS/JS via DAP)
--   <leader>tD  debug file   (TS/JS via DAP)
--   <leader>ts  toggle summary
--   <leader>to  last output (float)
--   <leader>tO  output panel
--   <leader>tv  run nearest with vitest under bun ("bunx vitest")
--   <leader>tV  run file    with vitest under bun ("bunx vitest")

local ok, neotest = pcall(require, "neotest")
if not ok then
  vim.notify("neotest not found", vim.log.levels.ERROR)
  return
end

-- --- Helpers -----------------------------------------------------------------

local function path_sep()
  return package.config:sub(1, 1)
end
local function dirname(p)
  return p:match("(.*" .. path_sep() .. ")") or "."
end
-- Return absolute monorepo root by looking upward for a git root (or fallback to cwd)
local function git_root(start)
  local found = vim.fs.find(".git", { upward = true, path = start, type = "directory" })[1]
  return found and dirname(found:sub(1, #found - 1)) or vim.uv.cwd()
end

-- Map: project -> absolute path
local function project_root_for(file_path)
  local root = git_root(file_path)

  local projects = { "checkout", "ecom", "bots" }

  for _, dir in ipairs(projects) do
    local abs = table.concat({ root, dir }, path_sep())
    if file_path:find(abs, 1, true) then
      return abs, dir
    end
  end
  -- Fallback: nearest package.json dir (works inside packages/apps/* too)
  local pkg = vim.fs.find("package.json", { upward = true, path = file_path })[1]
  if pkg then
    return dirname(pkg), nil
  end
  return root, nil
end

-- Point to project-specific Jest config files
local function jest_config_for(file_path)
  local sep = path_sep()
  local proj_abs, proj_name = project_root_for(file_path)
  if not proj_name then
    -- Not in checkout/ecom/bots -> let adapter auto-resolve
    return nil
  end

  if proj_name == "checkout" then
    -- Updated per your layout
    return table.concat({ proj_abs, "frontend", "jest.common.json" }, sep)
  elseif proj_name == "ecom" or proj_name == "bots" then
    return proj_abs .. sep .. "jest.config.json"
  end

  return nil
end

-- Use the package manager present in the project to pick a sensible jest command
local function jest_command_for(file_path)
  local proj_abs = project_root_for(file_path)
  -- Prefer local binaries to avoid globals; neotest-jest can auto-resolve if nil, too.
  -- Keeping this minimal; return nil to let the adapter do resolution.
  return nil
end

-- Current working directory should be the package root for correct resolution
local function cwd_for(file_path)
  local project_abs = project_root_for(file_path)
  return project_abs
end
-- --- Setup -------------------------------------------------------------------

neotest.setup({
  quickfix = { enabled = false },
  output = { open_on_run = true },
  discovery = { enabled = true },
  running = { concurrent = true },

  adapters = {
    -- Jest (TS/JS/TSX/JSX)
    -- Doc: jestCommand/jestConfigFile/cwd/env etc.  [3](https://github.com/nvim-neotest/neotest-jest)
    require("neotest-jest")({
      jestCommand = function(path)
        return jest_command_for(path)
      end,
      jestConfigFile = function(path)
        return jest_config_for(path)
      end,
      cwd = function(path)
        return cwd_for(path)
      end,
      env = { CI = "true" },
    }),

    -- Vitest (TS/JS/TSX/JSX)
    -- Supports monorepos and directory filtering; defaults to 'vitest' cmd. [4](https://github.com/marilari88/neotest-vitest)
    require("neotest-vitest")({
      -- Example: filter out big dirs; tweak if you like
      filter_dir = function(name, rel, root)
        return name ~= "node_modules" and name ~= "dist" and name ~= "build"
      end,
      -- If you want to make Vitest discovery stricter in the monorepo:
      -- is_test_file = function(file) return file:match("%.%a+%.spec%.%a+$") or file:match("%.%a+%.test%.%a+$") end,
    }),

    -- Bun test (experimental community adapter)
    -- If flaky, see the “bunx vitest” mappings below as a fallback. [1](https://github.com/jutonz/neotest-bun)[2](https://github.com/Arthur944/neotest-bun)
    (function()
      local ok_bun, bun = pcall(require, "neotest-bun")
      return ok_bun and bun or nil
    end)(),
  },
})

-- --- Keymaps -----------------------------------------------------------------

local map, opts = vim.keymap.set, { noremap = true, silent = true }

-- Run nearest test
map("n", "<leader>tc", function()
  require("neotest").run.run()
end, vim.tbl_extend("force", opts, { desc = "[T]est [C]urrent (nearest)" }))

-- Run whole file
map("n", "<leader>tf", function()
  require("neotest").run.run(vim.fn.expand("%"))
end, vim.tbl_extend("force", opts, { desc = "[T]est [F]ile" }))

-- Toggle summary / outputs
map("n", "<leader>ts", function()
  require("neotest").summary.toggle()
end, opts)
map("n", "<leader>to", function()
  require("neotest").output.open({ enter = true })
end, opts)
map("n", "<leader>tO", function()
  require("neotest").output_panel.toggle()
end, opts)

-- Debug via DAP (Jest/Vitest) using VSCode JS debug ("pwa-node")
map("n", "<leader>td", function()
  local ft = vim.bo.filetype
  local js_like = ft == "typescript" or ft == "typescriptreact" or ft == "javascript" or ft == "javascriptreact"
  if js_like then
    require("neotest").run.run({ strategy = "dap", dap = { type = "pwa-node" } })
  else
    require("neotest").run.run()
  end
end, vim.tbl_extend("force", opts, { desc = "[T]est [D]ebug nearest (JS/TS)" }))

map("n", "<leader>tD", function()
  local file = vim.fn.expand("%")
  local ft = vim.bo.filetype
  local js_like = ft == "typescript" or ft == "typescriptreact" or ft == "javascript" or ft == "javascriptreact"
  if js_like then
    require("neotest").run.run(file, { strategy = "dap", dap = { type = "pwa-node" } })
  else
    require("neotest").run.run(file)
  end
end, vim.tbl_extend("force", opts, { desc = "[T]est [D]ebug file (JS/TS)" }))

-- Fallback: run Vitest *under Bun* quickly (when you want bun runtime semantics)
map("n", "<leader>tv", function()
  require("neotest").run.run({ vitestCommand = "bunx vitest" })
end, vim.tbl_extend("force", opts, { desc = "Run nearest with bunx vitest" }))

map("n", "<leader>tV", function()
  require("neotest").run.run(vim.fn.expand("%"), { vitestCommand = "bunx vitest" })
end, vim.tbl_extend("force", opts, { desc = "Run file with bunx vitest" }))
