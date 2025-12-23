local M = {}

M.icons = { error = "", warn = "", info = "", hint = "" }

function M.get_workspace_diagnostics()
  local total = {
    info = 0,
    hints = 0,
    errors = 0,
    warnings = 0,
  }

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) then
      local name = vim.api.nvim_buf_get_name(buf)
      if name ~= "" then
        local stats = M.get_diagnostics_from_buffer(buf)

        total.info = total.info + stats.info
        total.hints = total.hints + stats.hints
        total.errors = total.errors + stats.errors
        total.warnings = total.warnings + stats.warnings
      end
    end
  end

  return total
end

function M.get_diagnostics_from_buffer(buf)
  local info = #vim.diagnostic.get(buf, { severity = vim.diagnostic.severity.INFO })
  local hints = #vim.diagnostic.get(buf, { severity = vim.diagnostic.severity.HINT })
  local errors = #vim.diagnostic.get(buf, { severity = vim.diagnostic.severity.ERROR })
  local warnings = #vim.diagnostic.get(buf, { severity = vim.diagnostic.severity.WARN })

  return {
    info = info,
    hints = hints,
    errors = errors,
    warnings = warnings,
  }
end

return M
