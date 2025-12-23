local EdgyBuilder = {}
EdgyBuilder.__index = EdgyBuilder

function EdgyBuilder:new(name, trigger)
  local settings = {
    name = name,
    side = "left",
    size = {
      height = 0.4,
    },
    filetype = name,
    user_command_name = nil,
    -- open = "vsplit",
    pinned = true,
    win = nil,
    buf = nil,
    wo = { winfixwidth = true },
    autocmds = {},
    buf_opts = {
      buftype = "nofile",
      bufhidden = "hide",
      swapfile = false,
    },
    fill = function()
      return {}
    end, -- user override
  }

  setmetatable(settings, EdgyBuilder)

  return settings
end

-- Set the panel location (left/right/top/bottom)
function EdgyBuilder:section(side, opts)
  self.side = side or self.side
  if opts then
    self.size = opts.size or self.size
    self.open = opts.open or self.open
    self.pinned = opts.pinned or self.pinned
    if opts.wo then
      self.wo = vim.tbl_deep_extend("force", self.wo, opts.wo)
    end
  end
  return self
end

-- Set buffer defaults and fill callback
function EdgyBuilder:buffer(opts)
  if opts then
    self.buf_opts = vim.tbl_deep_extend("force", self.buf_opts, opts)
  end
  return self
end

-- Set fill callback that returns lines to render
function EdgyBuilder:fill_with(fn)
  self.fill = fn
  return self
end

-- Register autocmds that refresh the buffer
function EdgyBuilder:on(event, callback)
  table.insert(self.autocmds, { event = event, callback = callback })
  return self
end

-- Internal: create buffer and window contents
function EdgyBuilder:_create_buffer(win)
  vim.api.nvim_win_set_buf(win, self.buf)

  -- Fill content
  local lines = self.fill() or {}
  vim.api.nvim_buf_set_lines(self.buf, 0, -1, false, lines)

  -- Setup autocmds to refresh panel
  for _, ac in ipairs(self.autocmds) do
    vim.api.nvim_create_autocmd(ac.event, {
      buffer = 0,
      callback = function()
        local update = self.fill()
        if update then
          vim.api.nvim_buf_set_lines(self.buf, 0, -1, false, update)
        end
        if ac.callback then
          ac.callback()
        end
      end,
    })
  end

  return self.buf
end

function EdgyBuilder:set_user_cmd(cmd)
  self.open = cmd

  vim.api.nvim_create_user_command(cmd, function()
    print("init win is", self.win)

    local win = vim.api.nvim_open_win(self.buf, true, {
      split = self.side,
      width = 30,
      height = self.size.height * 100,
    })

    self._create_buffer(win)
    self.win = win
  end, {})

  return self
end

function EdgyBuilder:create_initial_buffer()
  local buf = vim.api.nvim_create_buf(false, true)

  self.buf = buf

  -- Apply buffer options
  for k, v in pairs(self.buf_opts) do
    vim.api.nvim_buf_set_option(buf, k, v)
  end

  return self
end

-- Build the final edgy config spec
function EdgyBuilder:build()
  return {
    title = self.name,
    ft = self.filetype,

    open = self.open,

    pinned = self.pinned,
    size = self.size,
    wo = self.wo,

    init = function(win)
      -- self.win = win or self.win
      self:_create_buffer(win)
    end,
  }
end

-- local trigger = function(title)
--   local all_win_ids = vim.api.nvim_list_wins()
--   local edgy = require("edgy") -- owns the window titles
--   for _, win_id in ipairs(all_win_ids) do -- loop over all windows
--     local win = edgy.get_win(win_id) -- edgy window object has titles
--     if win and win.view.get_title() == title then
--       vim.api.nvim_set_current_win(win_id)
--     end
--   end
-- end
--
-- local workspace_panel = EdgyBuilder:new("Workspace Symbols")
--   :section("right", { height = 0.5 })
--   :fill_with(function()
--     local lines = {}
--     vim.lsp.buf_request_all(0, "workspace/symbol", { query = "" }, function(res)
--       for _, v in pairs(res) do
--         if v.result then
--           for _, s in ipairs(v.result) do
--             table.insert(lines, s.name)
--           end
--         end
--       end
--     end)
--     return lines
--   end)
--   :on("LspAttach")
--   :create_initial_buffer()
--   :set_user_cmd("EdgyWorkspaceSymbols")
--   :build()
--
-- local document_symbols = EdgyBuilder:new("Document Symbols")
--   :section("left", { height = 0.4 })
--   :buffer({ filetype = "edgy_document_symbols" })
--   :fill_with(function()
--     -- Try LSP first
--     local params = { textDocument = vim.lsp.util.make_text_document_params() }
--     local results = vim.lsp.buf_request_sync(0, "textDocument/documentSymbol", params, 200)
--
--     local lines = {}
--
--     if results then
--       for _, res in pairs(results) do
--         for _, symbol in ipairs(res.result or {}) do
--           local function walk(s, depth)
--             local indent = string.rep("│  ", depth)
--             table.insert(lines, indent .. "├─ " .. s.name)
--             if s.children then
--               for _, child in ipairs(s.children) do
--                 walk(child, depth + 1)
--               end
--             end
--           end
--           walk(symbol, 0)
--         end
--       end
--     end
--
--     if #lines > 0 then
--       return lines
--     end
--
--     -------------------------------------------------------
--     -- Fallback: Treesitter simple outline
--     -------------------------------------------------------
--     local ok, ts = pcall(require, "nvim-treesitter.ts_utils")
--     if ok then
--       local root = ts.get_root_for_position(0, 0)
--       if root then
--         for node, _ in root:iter_children() do
--           if node:type():match("function") or node:type():match("class") then
--             table.insert(lines, "├─ " .. node:type())
--           end
--         end
--       end
--     end
--
--     if #lines == 0 then
--       return { "No symbols found." }
--     end
--
--     return lines
--   end)
--   :on("LspAttach")
--   :on("BufWritePost")
--   :on("TextChanged")
--   :create_initial_buffer()
--   :set_user_cmd("EdgyDocumentSymbols")
--   :build()
--
-- local diagnostics_panel = EdgyBuilder:new("Diagnostics")
--   :section("left", { height = 0.3 })
--   :buffer({ filetype = "edgy_diagnostics" })
--   :fill_with(function()
--     local diags = vim.diagnostic.get(0)
--     local lines = {}
--
--     for _, d in ipairs(diags) do
--       local prefix = ({
--         [vim.diagnostic.severity.ERROR] = " ",
--         [vim.diagnostic.severity.WARN] = " ",
--         [vim.diagnostic.severity.INFO] = " ",
--         [vim.diagnostic.severity.HINT] = " ",
--       })[d.severity] or "• "
--
--       table.insert(lines, string.format("%s(%d) %s", prefix, d.lnum + 1, d.message))
--     end
--
--     if #lines == 0 then
--       return { "No diagnostics." }
--     end
--
--     return lines
--   end)
--   :on("DiagnosticChanged")
--   :on("BufEnter")
--   :create_initial_buffer()
--   :set_user_cmd("EdgyDiagnostics")
--   :build()
return EdgyBuilder
