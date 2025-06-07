local ts = vim.treesitter
local api = vim.api

local M = {}

-- Default configuration
local config = {
  enabled = true,
  min_lines = 15,
  virtual_text_color = "Comment",
  show_function_ends = true,
  show_param_hints = true,
  debounce_ms = 100,
}

-- Namespace for virtual text
local ns_id = api.nvim_create_namespace("ts_function_hints")

-- Timer for debouncing
local timer = nil

-- Setup function
function M.setup(opts)
  config = vim.tbl_deep_extend("force", config, opts or {})

  -- Create autocmds
  local group = api.nvim_create_augroup("TSFunctionHints", { clear = true })

  api.nvim_create_autocmd({ "TextChanged", "TextChangedI", "BufEnter", "WinScrolled" }, {
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
        M.update_hints()
      end, config.debounce_ms)
    end,
  })

  api.nvim_create_autocmd("BufLeave", {
    group = group,
    callback = function()
      M.clear_hints()
    end,
  })
end

-- Clear all virtual text
function M.clear_hints()
  local bufnr = api.nvim_get_current_buf()
  api.nvim_buf_clear_namespace(bufnr, ns_id, 0, -1)
end

-- Get function name from different node types
local function get_function_name(node)
  local node_type = node:type()

  if node_type == "function_declaration" then
    local name_node = node:field("name")[1]
    if name_node then
      return ts.get_node_text(name_node, 0)
    end
  elseif node_type == "method_definition" then
    local name_node = node:field("name")[1]
    if name_node then
      return ts.get_node_text(name_node, 0)
    end
  elseif node_type == "arrow_function" or node_type == "function_expression" then
    -- Try to find assignment or property name
    local parent = node:parent()
    if parent then
      if parent:type() == "variable_declarator" then
        local name_node = parent:field("name")[1]
        if name_node then
          return ts.get_node_text(name_node, 0)
        end
      elseif parent:type() == "assignment_expression" then
        local left = parent:field("left")[1]
        if left then
          return ts.get_node_text(left, 0)
        end
      elseif parent:type() == "property_definition" or parent:type() == "pair" then
        local key = parent:field("key")[1]
        if key then
          return ts.get_node_text(key, 0)
        end
      end
    end
    return "anonymous"
  end

  return "unknown"
end

-- Get parameter names from function parameters
local function get_param_names(node)
  local params = {}
  local param_nodes = node:field("parameters")

  if not param_nodes or #param_nodes == 0 then
    return params
  end

  local formal_params = param_nodes[1]
  if formal_params:type() ~= "formal_parameters" then
    return params
  end

  for child in formal_params:iter_children() do
    if child:type() == "required_parameter" or child:type() == "optional_parameter" then
      local pattern = child:field("pattern")[1]
      if pattern then
        if pattern:type() == "identifier" then
          table.insert(params, {
            name = ts.get_node_text(pattern, 0),
            node = pattern,
          })
        elseif pattern:type() == "object_pattern" then
          -- Handle destructuring
          for prop in pattern:iter_children() do
            if prop:type() == "object_assignment_pattern" then
              local left = prop:field("left")[1]
              if left and left:type() == "shorthand_property_identifier_pattern" then
                table.insert(params, {
                  name = ts.get_node_text(left, 0),
                  node = left,
                })
              end
            elseif prop:type() == "shorthand_property_identifier_pattern" then
              table.insert(params, {
                name = ts.get_node_text(prop, 0),
                node = prop,
              })
            end
          end
        elseif pattern:type() == "array_pattern" then
          -- Handle array destructuring
          for _, elem in ipairs(pattern:field("elements") or {}) do
            if elem:type() == "identifier" then
              table.insert(params, {
                name = ts.get_node_text(elem, 0),
                node = elem,
              })
            end
          end
        end
      end
    end
  end

  return params
end

-- Find all identifier usages within a function body
local function find_identifier_usages(body_node, param_name)
  local usages = {}

  local function traverse(node)
    if node:type() == "identifier" then
      local text = ts.get_node_text(node, 0)
      if text == param_name then
        local start_row, start_col = node:start()
        table.insert(usages, { row = start_row, col = start_col })
      end
    end

    for child in node:iter_children() do
      traverse(child)
    end
  end

  traverse(body_node)
  return usages
end

-- Main function to update hints
function M.update_hints()
  if not config.enabled then
    return
  end

  local bufnr = api.nvim_get_current_buf()
  local filetype = api.nvim_buf_get_option(bufnr, "filetype")

  -- Only process TypeScript/JavaScript files
  if not vim.tbl_contains({ "typescript", "javascript", "typescriptreact", "javascriptreact" }, filetype) then
    return
  end

  -- Clear existing virtual text
  M.clear_hints()

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

  -- Get visible range
  local win = api.nvim_get_current_win()
  local start_row = math.max(
    0,
    api.nvim_win_call(win, function()
      return vim.fn.line("w0") - 1
    end)
  )
  local end_row = api.nvim_win_call(win, function()
    return vim.fn.line("w$") - 1
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
    local start_row_node, _, end_row_node, _ = node:range()
    local line_count = end_row_node - start_row_node + 1

    -- Show function end hints
    if config.show_function_ends and line_count >= config.min_lines then
      local func_name = get_function_name(node)
      local virtual_text = string.format("end of %s", func_name)

      api.nvim_buf_set_extmark(bufnr, ns_id, end_row_node, -1, {
        virt_text = { { virtual_text, config.virtual_text_color } },
        virt_text_pos = "eol",
      })
    end

    -- Show parameter hints
    if config.show_param_hints then
      local params = get_param_names(node)
      if #params > 0 then
        local body = node:field("body")[1]
        if body then
          for _, param in ipairs(params) do
            local usages = find_identifier_usages(body, param.name)
            for _, usage in ipairs(usages) do
              -- Only show hint if it's in visible range and not the parameter declaration itself
              if usage.row >= start_row and usage.row <= end_row then
                local param_start_row, param_start_col = param.node:start()
                if not (usage.row == param_start_row and usage.col == param_start_col) then
                  local virtual_text = string.format("← param: %s", param.name)

                  api.nvim_buf_set_extmark(bufnr, ns_id, usage.row, usage.col, {
                    virt_text = { { virtual_text, config.virtual_text_color } },
                    virt_text_pos = "eol",
                  })
                end
              end
            end
          end
        end
      end
    end
  end
end

-- Toggle the plugin
function M.toggle()
  config.enabled = not config.enabled
  if config.enabled then
    M.update_hints()
    print("TS Function Hints: Enabled")
  else
    M.clear_hints()
    print("TS Function Hints: Disabled")
  end
end

-- Enable the plugin
function M.enable()
  config.enabled = true
  M.update_hints()
  print("TS Function Hints: Enabled")
end

-- Disable the plugin
function M.disable()
  config.enabled = false
  M.clear_hints()
  print("TS Function Hints: Disabled")
end

-- Get current configuration
function M.get_config()
  return vim.deepcopy(config)
end

return M
