local helpers = {}

function helpers.gitsigns_data(bufnr, type)
  local ok, dict = pcall(vim.api.nvim_buf_get_var, bufnr, 'gitsigns_status_dict')
  if not ok or vim.tbl_isempty(dict) or not dict[type] then
    return 0
  end
  return dict[type]
end

function helpers.get_diagnostic(level)
  local configs = {
    -- stylua: ignore start
    info    = { color = "DiagnosticSignInfo",  icon = "", severity = vim.diagnostic.severity.I },
    hint    = { color = "DiagnosticSignHint",  icon = "", severity = vim.diagnostic.severity.H },
    warning = { color = "DiagnosticSignWarn",  icon = "", severity = vim.diagnostic.severity.W },
    error   = { color = "DiagnosticSignError", icon = "", severity = vim.diagnostic.severity.E },
    -- stylua: ignore end
  }

  if vim.diagnostic.is_disabled(0) then
    return ""
  end

  local config = configs[level]
  local count = #vim.diagnostic.get(0, { severity = config.severity })

  if count > 0 then
    return "%#" .. config.color .. "#" .. config.icon .. " " .. count
  end

  return ""
end

return helpers
