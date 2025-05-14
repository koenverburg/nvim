local virtual_text_enabled = true
local current_separator = "solid" -- default style

local separator_styles = {
  solid = "──────",
  fade = "  ░▒▓██",
  dot = "●",
  minimal = "",
}

local ns = vim.api.nvim_create_namespace("indented_virtual_text")

local diagnostic_config = {
  [vim.diagnostic.severity.ERROR] = { hl = "DiagnosticSignError", icon = "" },
  [vim.diagnostic.severity.WARN] = { hl = "DiagnosticSignWarn", icon = "" },
  [vim.diagnostic.severity.INFO] = { hl = "DiagnosticSignInfo", icon = "" },
  [vim.diagnostic.severity.HINT] = { hl = "DiagnosticSignHint", icon = "" },
}

local function render_diagnostics(bufnr, diagnostics)
  vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

  if not virtual_text_enabled then
    return
  end

  local line_map = {} -- cache line text & accumulated virt_text per line
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  for _, diag in ipairs(diagnostics) do
    local lnum = diag.lnum
    local cfg = diagnostic_config[diag.severity] or diagnostic_config[vim.diagnostic.severity.INFO]
    local msg = diag.message:gsub("[%c]", " ")

    if not line_map[lnum] then
      local line_text = lines[lnum + 1] or ""
      local len = vim.fn.strdisplaywidth(line_text)

      line_map[lnum] = {
        cfg = cfg,
        virt_text = {},
        col = math.max(80, len + 1),
      }
    end

    local entry = line_map[lnum]
    vim.list_extend(entry.virt_text, {
      { separator_styles[current_separator], cfg.hl },
      { " " },
      { cfg.icon, cfg.hl },
      { " " .. msg, cfg.hl },
    })
  end

  for lnum, entry in pairs(line_map) do
    if lnum < #lines then
      vim.api.nvim_buf_set_extmark(bufnr, ns, lnum, 0, {
        sign_text = entry.cfg.icon,
        sign_hl_group = entry.cfg.hl,
        virt_text = entry.virt_text,
        virt_text_win_col = entry.col,
        hl_mode = "combine",
      })
    end
  end
end

vim.diagnostic.handlers.virtual_text = {
  show = function(_, bufnr, diagnostics, _)
    render_diagnostics(bufnr, diagnostics)
  end,
  hide = function(_, bufnr)
    vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
  end,
}

vim.diagnostic.config({
  signs = true,
  underline = true,
  virtual_text = virtual_text_enabled,
  severity_sort = true,
})

vim.keymap.set("n", "<leader>dv", function()
  virtual_text_enabled = not virtual_text_enabled
  vim.diagnostic.show(nil, 0)
end, { desc = "Toggle custom virtual text" })

vim.keymap.set("n", "<leader>ds", function()
  local keys = vim.tbl_keys(separator_styles)
  for i, key in ipairs(keys) do
    if key == current_separator then
      current_separator = keys[(i % #keys) + 1]
      break
    end
  end
  vim.diagnostic.show(nil, 0)
end, { desc = "Cycle diagnostic separator style" })
