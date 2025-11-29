-- edgy_builder.lua
local EdgyBuilder = {}
EdgyBuilder.__index = EdgyBuilder

function EdgyBuilder:new(name, trigger)
  local settings = {
    name = name,
    side = "left",
    size = 30,
    filetype = name,
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
  local buf = vim.api.nvim_create_buf(false, true)

  self.buf = buf

  -- Apply buffer options
  for k, v in pairs(self.buf_opts) do
    vim.api.nvim_buf_set_option(buf, k, v)
  end

  vim.api.nvim_win_set_buf(win, buf)

  -- Fill content
  local lines = self.fill() or {}
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  -- Setup autocmds to refresh panel
  for _, ac in ipairs(self.autocmds) do
    vim.api.nvim_create_autocmd(ac.event, {
      buffer = 0,
      callback = function()
        local update = self.fill()
        if update then
          vim.api.nvim_buf_set_lines(buf, 0, -1, false, update)
        end
        if ac.callback then
          ac.callback()
        end
      end,
    })
  end

  return buf
end

function EdgyBuilder:set_user_cmd()
  vim.api.nvim_create_user_command("VoidDiagnosticsToggle", function()
    local win = vim.api.nvim_open_win(self.buf, true, {
      split = self.side,
      -- relative = "editor",
      width = self.width,
      height = self.height,
      -- row = math.floor((height - self.height) / 2),
      -- col = math.floor((width - self.width) / 2),
      -- focusable = self.focusable,
    })

    self.win = win
  end, {})
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
      self:_create_buffer(win)
    end,
  }
end

return EdgyBuilder
