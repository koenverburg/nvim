local M = {}
local api = vim.api
local ts = vim.treesitter

-- Helper function to get text from a node
local function get_node_text(node, bufnr)
  local start_row, start_col, end_row, end_col = node:range()
  local lines = api.nvim_buf_get_text(bufnr, start_row, start_col, end_row, end_col, {})
  return table.concat(lines, "\n")
end

-- Helper function to get parameters text
local function get_parameters_text(node, bufnr)
  local params_node = node:field("parameters")[1]
  if params_node then
    return get_node_text(params_node, bufnr)
  end
  return "()"
end

-- Helper function to get function body text
local function get_body_text(node, bufnr)
  local body_node = node:field("body")[1]
  if body_node then
    return get_node_text(body_node, bufnr)
  end
  return "{}"
end

-- Helper function to get function name
local function get_function_name(node, bufnr)
  local name_node = node:field("name")[1]
  if name_node then
    return get_node_text(name_node, bufnr)
  end
  return nil
end

-- Check if arrow function has direct return (no braces)
local function is_direct_return_arrow(node, bufnr)
  local body_node = node:field("body")[1]
  if body_node then
    return body_node:type() ~= "statement_block"
  end
  return false
end

-- Convert regular function to arrow function
local function function_to_arrow(node, bufnr, export_info)
  local name = get_function_name(node, bufnr)
  local params = get_parameters_text(node, bufnr)
  local body = get_body_text(node, bufnr)

  if not name then
    return nil -- Can't convert anonymous functions this way
  end

  local export_prefix = ""
  local var_type = "const"

  if export_info then
    if export_info.type == "export" then
      export_prefix = "export "
    elseif export_info.type == "export_default" then
      export_prefix = "export "
      var_type = "default"
    end
  end

  -- Format as [export] const name = (params) => body
  local arrow_func
  if var_type == "default" then
    arrow_func = string.format("%sdefault %s => %s", export_prefix, params, body)
  else
    arrow_func = string.format("%s%s %s = %s => %s", export_prefix, var_type, name, params, body)
  end
  return arrow_func
end

-- Convert arrow function to regular function
local function arrow_to_function(node, bufnr, var_name, export_type)
  local params = get_parameters_text(node, bufnr)
  local body_node = node:field("body")[1]
  local body_text = get_node_text(body_node, bufnr)

  local function_body
  if is_direct_return_arrow(node, bufnr) then
    -- Direct return arrow function: const fn = x => x * 2
    function_body = string.format("{\n  return %s;\n}", body_text)
  else
    -- Block body arrow function: const fn = x => { return x * 2; }
    function_body = body_text
  end

  local export_prefix = ""
  if export_type == "export" then
    export_prefix = "export "
  elseif export_type == "export_default" then
    export_prefix = "export default "
  end

  local regular_func = string.format("%sfunction %s%s %s", export_prefix, var_name or "unnamed", params, function_body)
  return regular_func
end

-- Find the function node at cursor and determine its type
local function find_function_at_cursor(bufnr)
  local parser = ts.get_parser(bufnr)
  if not parser then
    return nil, nil
  end

  local tree = parser:parse()[1]
  if not tree then
    return nil, nil
  end

  local root = tree:root()
  local cursor = api.nvim_win_get_cursor(0)
  local cursor_row = cursor[1] - 1
  local cursor_col = cursor[2]

  -- Query for different function types including exports
  local function_query_string = [[
    (function_declaration) @func_decl
    (arrow_function) @arrow_func

    ; Regular variable declaration with arrow function
    (variable_declarator
      name: (identifier) @var_name
      value: (arrow_function) @arrow_func_with_var)

    ; Export const/let/var with arrow function
    (export_statement
      declaration: (lexical_declaration
        declarations: (variable_declarator
          name: (identifier) @export_var_name
          value: (arrow_function) @export_arrow_func)))

    ; Export default arrow function
    (export_statement
      declaration: (arrow_function) @export_default_arrow)

    ; Export function declaration
    (export_statement
      declaration: (function_declaration) @export_func_decl)
  ]]

  local query = ts.query.parse("typescript", function_query_string)

  -- Store all matches to find the most specific one
  local matches = {}

  for pattern, node, metadata in query:iter_captures(root, bufnr, 0, -1) do
    local start_row, start_col, end_row, end_col = node:range()

    -- Check if cursor is within this node
    if cursor_row >= start_row and cursor_row <= end_row then
      if cursor_row == start_row and cursor_col < start_col then
        -- Skip if cursor is before the node
      elseif cursor_row == end_row and cursor_col > end_col then
        -- Skip if cursor is after the node
      else
        -- Found a function containing the cursor
        local capture_name = query.captures[pattern]
        local range_size = (end_row - start_row) * 1000 + (end_col - start_col)

        table.insert(matches, {
          node = node,
          capture_name = capture_name,
          range_size = range_size,
          start_row = start_row,
          start_col = start_col,
          end_row = end_row,
          end_col = end_col,
        })
      end
    end
  end

  if #matches == 0 then
    return nil, nil
  end

  -- Sort by range size to get the most specific match
  table.sort(matches, function(a, b)
    return a.range_size < b.range_size
  end)

  local match = matches[1]
  local node = match.node
  local capture_name = match.capture_name

  -- Handle different capture types
  if capture_name == "func_decl" then
    return node, "function_declaration", nil, nil
  elseif capture_name == "export_func_decl" then
    return node, "function_declaration", nil, { type = "export" }
  elseif capture_name == "arrow_func" then
    return node, "arrow_function", nil, nil
  elseif capture_name == "arrow_func_with_var" then
    -- Find the variable name for this arrow function
    local parent = node:parent()
    if parent and parent:type() == "variable_declarator" then
      local var_name_node = parent:field("name")[1]
      if var_name_node then
        local var_name = get_node_text(var_name_node, bufnr)
        return node, "arrow_function_with_var", var_name, nil
      end
    end
    return node, "arrow_function", nil, nil
  elseif capture_name == "export_arrow_func" then
    -- Find the variable name for exported arrow function
    local parent = node:parent() -- variable_declarator
    if parent and parent:type() == "variable_declarator" then
      local var_name_node = parent:field("name")[1]
      if var_name_node then
        local var_name = get_node_text(var_name_node, bufnr)
        return node, "arrow_function_with_var", var_name, { type = "export" }
      end
    end
    return node, "arrow_function", nil, { type = "export" }
  elseif capture_name == "export_default_arrow" then
    return node, "arrow_function", nil, { type = "export_default" }
  end

  return nil, nil
end

-- Main refactor function
function M.refactor_function()
  local bufnr = api.nvim_get_current_buf()
  local filetype = api.nvim_buf_get_option(bufnr, "filetype")

  -- Only process TypeScript/JavaScript files
  if not vim.tbl_contains({ "typescript", "javascript", "typescriptreact", "javascriptreact" }, filetype) then
    print("Function refactoring only works in TypeScript/JavaScript files")
    return
  end

  local node, func_type, var_name, export_info = find_function_at_cursor(bufnr)

  if not node then
    print("No function found at cursor position")
    return
  end

  local start_row, start_col, end_row, end_col = node:range()
  local new_text = nil
  -- local replace_entire_statement = false

  if func_type == "function_declaration" then
    -- Convert regular function to arrow function
    new_text = function_to_arrow(node, bufnr, export_info)
    if new_text then
      if export_info then
        print("Converting exported function declaration to arrow function")
      else
        print("Converting function declaration to arrow function")
      end

      -- For exported functions, we need to replace the entire export statement
      if export_info then
        local export_node = node:parent() -- export_statement
        if export_node then
          start_row, start_col, end_row, end_col = export_node:range()
        end
      end
    else
      print("Cannot convert anonymous function declaration")
      return
    end
  elseif func_type == "arrow_function" then
    -- Handle standalone arrow functions (like export default)
    if export_info and export_info.type == "export_default" then
      -- This is an export default arrow function
      print("Cannot convert export default arrow function without variable assignment")
      print("Try: export default function(params) { ... } instead")
      return
    else
      print("Cannot convert standalone arrow function without variable assignment")
      return
    end
  elseif func_type == "arrow_function_with_var" then
    -- Convert arrow function to regular function
    if var_name then
      new_text = arrow_to_function(node, bufnr, var_name, export_info and export_info.type)

      if export_info then
        print("Converting exported arrow function to function declaration")
      else
        print("Converting arrow function to function declaration")
      end

      -- For variable declarator with arrow function, we need to replace the entire declaration
      local parent = node:parent() -- variable_declarator
      if parent then
        if export_info then
          -- For exports, go up to the export_statement
          local lexical_decl = parent:parent() -- lexical_declaration
          if lexical_decl then
            local export_stmt = lexical_decl:parent() -- export_statement
            if export_stmt then
              start_row, start_col, end_row, end_col = export_stmt:range()
            end
          end
        else
          -- For regular variables, go up to the variable_declaration
          local var_decl = parent:parent() -- variable_declaration
          if var_decl then
            start_row, start_col, end_row, end_col = var_decl:range()
          end
        end
      end
    else
      print("Cannot determine variable name for arrow function")
      return
    end
  end

  if new_text then
    -- Replace the text
    local lines = vim.split(new_text, "\n")
    api.nvim_buf_set_text(bufnr, start_row, start_col, end_row, end_col, lines)

    -- Position cursor at the start of the new function
    api.nvim_win_set_cursor(0, { start_row + 1, start_col })
  end
end

-- Set up keymap
function M.setup_keymaps()
  vim.keymap.set("n", "<leader>rf", function()
    M.refactor_function()
  end, {
    desc = "Refactor function (regular ↔ arrow)",
    silent = true,
  })

  -- Alternative keymaps:
  -- vim.keymap.set('n', '<leader>fr', M.refactor_function, { desc = "Function refactor" })
  -- vim.keymap.set('n', 'grf', M.refactor_function, { desc = "Refactor function" })
end

return M
