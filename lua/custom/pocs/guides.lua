-- TypeScript Function Guide Lines Plugin
-- File: lua/ts-function-guides/init.lua

local ts = vim.treesitter
local api = vim.api

local M = {}

-- Default configuration
local config = {
  enabled = true,
  min_lines = 5,
  guide_char = "│",
  guide_color = "Comment",
  debounce_ms = 100,
}

-- Namespace for virtual text
local ns_id = api.nvim_create_namespace("ts_function_guides")

-- Timer for debouncing
local timer = nil

-- Setup function
function M.setup(opts)
  config = vim.tbl_deep_extend("force", config, opts or {})

  -- Create autocmds
  local group = api.nvim_create_augroup("TSFunctionGuides", { clear = true })

  api.nvim_create_autocmd({ "TextChanged", "TextChangedI", "BufEnter", "WinScrolled", "WinResized" }, {
    group = group,
    pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
    callback = function()
      if not config.enabled then
        return
      end

      -- Debounce the updates
      if timer then
        timer:stop()
      end

      timer = vim.defer_fn(function()
        M.update_guides()
      end, config.debounce_ms)
    end,
  })

  api.nvim_create_autocmd("BufLeave", {
    group = group,
    callback = function()
      M.clear_guides()
    end,
  })
end

-- Clear all guide lines
function M.clear_guides()
  local bufnr = api.nvim_get_current_buf()
  api.nvim_buf_clear_namespace(bufnr, ns_id, 0, -1)
end

-- Get the indentation level of a line
local function get_indent_level(bufnr, line_num)
  local line = api.nvim_buf_get_lines(bufnr, line_num, line_num + 1, false)[1]
  if not line then
    return 0
  end

  local indent = 0
  for i = 1, #line do
    local char = line:sub(i, i)
    if char == " " then
      indent = indent + 1
    elseif char == "\t" then
      indent = indent + vim.bo.tabstop
    else
      break
    end
  end

  return indent
end

-- Create guide line with indentation
local function create_indent_guide(bufnr, line_num)
  local indent = get_indent_level(bufnr, line_num)
  local spaces = string.rep(" ", indent)
  return spaces .. config.guide_char
end

-- Check if function body has enough lines
local function should_add_guides(node)
  local start_row, _, end_row, _ = node:range()
  print("start", start_row)
  print("end", end_row)
  local line_count = end_row - start_row + 1
  return line_count > config.min_lines
end

-- Get the actual body node of a function
local function get_function_body(node)
  local node_type = node:type()

  if node_type == "function_declaration" or node_type == "function_expression" or node_type == "method_definition" then
    local body = node:field("body")[1]
    return body
  elseif node_type == "arrow_function" then
    local body = node:field("body")[1]
    -- Arrow functions can have expression bodies or block bodies
    if body and body:type() == "statement_block" then
      return body
    elseif body then
      -- Expression body - check if it's complex enough (multiline)
      local start_row, _, end_row, _ = body:range()
      if end_row > start_row then
        return body
      end
    end
  end

  return nil
end

-- Main function to update guide lines
function M.update_guides()
  if not config.enabled then
    return
  end

  local bufnr = api.nvim_get_current_buf()
  local filetype = api.nvim_buf_get_option(bufnr, "filetype")

  -- Only process TypeScript/JavaScript files
  if not vim.tbl_contains({ "typescript", "javascript", "typescriptreact", "javascriptreact" }, filetype) then
    return
  end

  -- Clear existing guide lines
  M.clear_guides()

  -- Get the syntax tree
  local parser = ts.get_parser(bufnr)
  if not parser then
    return
  end

  local tree = parser:parse()[1]
  if not tree then
    return
  end

  local root = tree:root()

  -- Get visible range (with some buffer for smooth scrolling)
  local win = api.nvim_get_current_win()
  local start_row = math.max(
    0,
    api.nvim_win_call(win, function()
      return vim.fn.line("w0") - 5
    end)
  )
  local end_row = api.nvim_win_call(win, function()
    return vim.fn.line("w$") + 5
  end)

  -- Query for functions
  local query_string = [[
    (function_declaration) @function
    (method_definition) @function
    (arrow_function) @function
    (function_expression) @function
  ]]

  local query = ts.query.parse("typescript", query_string)

  for _, node in query:iter_captures(root, bufnr, start_row, end_row + 1) do
    if should_add_guides(node) then
      local body = get_function_body(node)

      if body then
        local func_start_row, _, func_end_row, _ = node:range()

        -- Create simple guide lines at the function's indentation level
        local start_guide = create_indent_guide(bufnr, func_start_row)
        local end_guide = create_indent_guide(bufnr, func_end_row)

        -- Add virtual lines with just the guide character at proper indentation
        -- if func_start_row > 0 then
        --   api.nvim_buf_set_extmark(bufnr, ns_id, func_start_row - 1, 0, {
        --     virt_lines = { { { start_guide, config.guide_color } } },
        --     virt_lines_above = true,
        --   })
        -- end

        api.nvim_buf_set_extmark(bufnr, ns_id, func_end_row, 0, {
          virt_lines = { { { end_guide, config.guide_color } } },
          virt_lines_above = false,
        })

        -- Add vertical guide lines between start and end
        for line_num = func_start_row + 1, func_end_row - 1 do
          local guide_line = create_indent_guide(bufnr, func_start_row)
          api.nvim_buf_set_extmark(bufnr, ns_id, line_num, 0, {
            virt_text = { { guide_line, config.guide_color } },
            virt_text_pos = "overlay",
          })
        end
      end
    end
  end
end

-- Toggle the plugin
function M.toggle()
  config.enabled = not config.enabled
  if config.enabled then
    M.update_guides()
    print("TS Function Guides: Enabled")
  else
    M.clear_guides()
    print("TS Function Guides: Disabled")
  end
end

-- Enable the plugin
function M.enable()
  config.enabled = true
  M.update_guides()
  print("TS Function Guides: Enabled")
end

-- Disable the plugin
function M.disable()
  config.enabled = false
  M.clear_guides()
  print("TS Function Guides: Disabled")
end

-- Update configuration
function M.update_config(new_config)
  config = vim.tbl_deep_extend("force", config, new_config or {})

  if config.enabled then
    M.update_guides()
  end
end

-- Get current configuration
function M.get_config()
  return vim.deepcopy(config)
end

return M
