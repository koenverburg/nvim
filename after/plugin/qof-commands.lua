local function build_mock_declaration(func_name)
  if func_name == "" then
    return nil
  end

  local capitalised = func_name:sub(1, 1):upper() .. func_name:sub(2)

  return string.format("const mock%s = %s as jest.MockedFunction<typeof %s>", capitalised, func_name, func_name)
end

local function mock_function_prompt()
  local func_name = vim.fn.input("Function to mock: ")

  if not func_name then
    return
  end

  -- Trim whitespace
  func_name = func_name:gsub("^%s+", ""):gsub("%s+$", "")
  if func_name == "" then
    return
  end

  local declaration = build_mock_declaration(func_name)
  if not declaration then
    return
  end

  local bufnr = vim.api.nvim_get_current_buf()
  local row, _col = unpack(vim.api.nvim_win_get_cursor(0))

  vim.api.nvim_buf_set_lines(bufnr, row - 1, row, false, { declaration })

  vim.notify("Mock inserted: " .. declaration, vim.log.levels.INFO)
end

vim.api.nvim_create_user_command("MockFunction", mock_function_prompt, {})
