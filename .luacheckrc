-- Use LuaJIT standard (Neovim uses LuaJIT)
std = "luajit"

-- Enable caching for faster repeated checks
cache = true

-- Set maximum line length (optional)
max_line_length = 120

-- Maximum cyclomatic complexity
max_cyclomatic_complexity = 15

-- Codes to ignore globally
ignore = {
  -- Unused variables (sometimes intentional in callbacks)
  "211", -- unused local variable
  "212", -- unused argument
  "213", -- unused loop variable
  "214", -- unused variable with "_" prefix

  -- Line length (if you prefer flexibility)
  "631", -- line is too long

  -- Whitespace (handled by StyLua)
  "611", -- line contains only whitespace
  "612", -- line contains trailing whitespace
  "613", -- trailing whitespace in string
  "614", -- trailing whitespace in comment

  -- Globals (if you have intentional globals)
  "111", -- setting non-standard global variable
  "112", -- mutating non-standard global variable
  "113", -- accessing undefined variable
  "121", -- setting read-only global variable
  "122", -- setting read-only field of global variable
  "131", -- unused global variable
  "142", -- setting undefined field of global variable
  "143", -- accessing undefined field of global variable
}

-- Read-only globals (can be read but not modified)
read_globals = {
  "vim",
}

-- Globals that can be set and read
globals = {
  "vim",
  "awesome",  -- if you're working with AwesomeWM
  "client",   -- AwesomeWM
  "root",     -- AwesomeWM
}

-- Neovim-specific global modules
-- files["**/*_spec.lua"] = {
--   std = "+busted",
-- }

-- files["spec/**/*.lua"] = {
--   std = "+busted",
-- }

-- files["test/**/*.lua"] = {
--   std = "+busted",
-- }

-- Exclude directories and files
exclude_files = {
  ".luarocks/",
  "lua_modules/",
  ".git/",
  "vendor/",
  "deps/",
  "*.rockspec",
}
