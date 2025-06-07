local group = vim.api.nvim_create_augroup("OoO", {})

local function au(typ, pattern, cmdOrFn)
  if type(cmdOrFn) == "function" then
    vim.api.nvim_create_autocmd(typ, { pattern = pattern, callback = cmdOrFn, group = group })
  else
    vim.api.nvim_create_autocmd(typ, { pattern = pattern, command = cmdOrFn, group = group })
  end
end

local virtual_text_enabled = true

local ns = vim.api.nvim_create_namespace("indented_virtual_text")

local diagnostic_config = {
  [vim.diagnostic.severity.ERROR] = { hl = "DiagnosticSignError", text_hl = "DiagnosticError", icon = "" },
  [vim.diagnostic.severity.WARN] = { hl = "DiagnosticSignWarn", text_hl = "DiagnosticWarn", icon = "" },
  [vim.diagnostic.severity.INFO] = { hl = "DiagnosticSignInfo", text_hl = "DiagnosticInfo", icon = "" },
  [vim.diagnostic.severity.HINT] = { hl = "DiagnosticSignHint", text_hl = "DiagnosticHint", icon = "" },
}

for _, sign in ipairs(diagnostic_config) do
  vim.fn.sign_define(sign.hl, { texthl = sign.hl, text = sign.icon, numhl = "" })
end

-- Set up highlight groups - remove background colors, keep only foreground
vim.api.nvim_set_hl(0, "DiagnosticSignError", { fg = "#ff5555" })
vim.api.nvim_set_hl(0, "DiagnosticSignWarn", { fg = "#facc15" })
vim.api.nvim_set_hl(0, "DiagnosticSignInfo", { fg = "#5ad4e6" })
vim.api.nvim_set_hl(0, "DiagnosticSignHint", { fg = "#a78bfa" })

-- Create white highlight for tree lines and icons
vim.api.nvim_set_hl(0, "DiagnosticWhite", { link = "Comment" })
-- vim.api.nvim_set_hl(0, "your-group", { link = "another-group" })

local function filter(diagnostics, bufnr)
  local filtered_diag = {}
  for _, d in ipairs(diagnostics) do
    if d.bufnr == bufnr then
      table.insert(filtered_diag, 1, d)
    end
  end
  return filtered_diag
end

local function render_diagnostics(diagnostics)
  if not virtual_text_enabled then
    return
  end

  local bufnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local line_map = {}

  -- Build the line map
  for _, diag in ipairs(filter(diagnostics, bufnr)) do
    local lnum = diag.lnum
    local cfg = diagnostic_config[diag.severity] or diagnostic_config[vim.diagnostic.severity.INFO]
    local msg = diag.message:gsub("[%c]", " ")

    if not line_map[lnum] then
      local line_len = vim.fn.strdisplaywidth(lines[lnum + 1] or "")

      line_map[lnum] = {}

      local entry = line_map[lnum]
      entry.list = {}
      entry.col = math.max(80, line_len + 1)

      table.insert(entry.list, {
        cfg = cfg,
        icon = cfg.icon,
        msg = msg,
      })
    else
      local entry = line_map[lnum]

      table.insert(entry.list, {
        cfg = cfg,
        icon = cfg.icon,
        msg = msg,
      })
    end
  end

  -- Render diagnostics
  for lnum, entry in pairs(line_map) do
    local count = #entry.list
    local first = entry.list[1]

    local start = #entry.list > 1 and "─┬─ " or "─── "

    -- Render first line with proper colors
    vim.api.nvim_buf_set_extmark(bufnr, ns, lnum, 0, {
      virt_text = {
        { start, "DiagnosticWhite" },
        { first.icon .. " ", "DiagnosticWhite" },
        { first.msg, first.cfg.text_hl },
      },
      virt_text_pos = "overlay",
      sign_text = first.cfg.icon,
      sign_hl_group = first.cfg.hl,
      virt_text_win_col = entry.col,
      hl_mode = "combine",
    })

    -- Render additional lines using virt_lines to push down content
    if count > 1 then
      local virt_lines_content = {}

      for i = 2, count do
        local cfg = entry.list[i].cfg
        local line_char = (i == count) and " ╰─ " or " ├─ "

        table.insert(virt_lines_content, {
          { string.rep(" ", entry.col), "DiagnosticWhite" },
          { line_char, "DiagnosticWhite" },
          { entry.list[i].icon .. " ", "DiagnosticWhite" },
          { entry.list[i].msg, cfg.text_hl },
        })
      end

      vim.api.nvim_buf_set_extmark(bufnr, ns, lnum, 0, {
        virt_lines = virt_lines_content,
      })
    end
  end
end

au("InsertEnter", nil, function()
  vim.diagnostic.enable(false)
end)

au("InsertLeave", nil, function()
  vim.diagnostic.enable(true)
end)

vim.diagnostic.handlers.virtual_text = {
  show = function(_, bufnr, diagnostics, _)
    vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
    render_diagnostics(diagnostics)
  end,
  hide = function(_, bufnr)
    vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
  end,
}

vim.diagnostic.config({
  signs = true,
  underline = true,
  virtual_text = {
    current_line = virtual_text_enabled,
  },
  severity_sort = true,
})

vim.keymap.set("n", "<leader>dv", function()
  virtual_text_enabled = not virtual_text_enabled
  vim.diagnostic.show(nil, 0)
end, { desc = "Toggle custom virtual text" })
