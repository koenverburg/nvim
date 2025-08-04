local M = {}

-- Configuration
local config = {
  typing_speed = 50, -- milliseconds between characters
  pause_duration = 1000, -- milliseconds to pause between messages
  erase_speed = 30, -- milliseconds between character deletions
}

-- Messages to display in sequence
local messages = {
  "connecting...",
  "connected",
  "> I'm here, past and future you",
  "> hold fast, the storm it will pass over",
  "> take action today",
}

-- Create the intro buffer and window
local function create_intro_window()
  local buf = vim.api.nvim_create_buf(false, true)
  local width = vim.o.columns
  local height = vim.o.lines

  -- Calculate window dimensions (centered)
  local win_width = math.min(80, width - 4)
  local win_height = math.min(20, height - 4)
  local row = math.floor((height - win_height) / 2)
  local col = math.floor((width - win_width) / 2)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = win_width,
    height = win_height,
    row = row,
    col = col,
    style = "minimal",
  })

  -- Set buffer options
  vim.api.nvim_buf_set_option(buf, "modifiable", false)
  vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
  vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
  vim.api.nvim_buf_set_option(buf, "swapfile", false)

  -- Set window options
  vim.api.nvim_win_set_option(win, "cursorline", false)
  vim.api.nvim_win_set_option(win, "number", false)
  vim.api.nvim_win_set_option(win, "relativenumber", false)
  vim.api.nvim_win_set_option(win, "signcolumn", "no")
  vim.api.nvim_win_set_option(win, "wrap", false)

  -- Hide cursor
  vim.api.nvim_win_set_option(win, "guicursor", "a:Cursor/lCursor-blinkon0")
  vim.cmd("set guicursor+=a:block-blinkon0")

  -- Position cursor at the end of buffer to minimize visibility
  vim.api.nvim_win_set_cursor(win, { 1, 0 })

  return buf, win
end

-- Type text character by character
local function type_text(buf, line, text, callback)
  local current_text = ""
  local i = 1
  local win_width = vim.api.nvim_win_get_width(0)

  -- Ensure the line exists first
  local line_count = vim.api.nvim_buf_line_count(buf)
  if line >= line_count then
    vim.api.nvim_buf_set_option(buf, "modifiable", true)
    local empty_lines = {}
    for j = line_count, line do
      table.insert(empty_lines, "")
    end
    vim.api.nvim_buf_set_lines(buf, line_count, -1, false, empty_lines)
    vim.api.nvim_buf_set_option(buf, "modifiable", false)
  end

  local function type_char()
    if i <= #text then
      current_text = current_text .. text:sub(i, i)

      -- Center the text
      local padding = math.max(0, math.floor((win_width - #current_text) / 2))
      local centered_text = string.rep(" ", padding) .. current_text

      vim.api.nvim_buf_set_option(buf, "modifiable", true)
      vim.api.nvim_buf_set_lines(buf, line, line + 1, false, { centered_text })
      vim.api.nvim_buf_set_option(buf, "modifiable", false)
      i = i + 1
      vim.defer_fn(type_char, config.typing_speed)
    else
      if callback then
        vim.defer_fn(callback, config.pause_duration)
      end
    end
  end

  type_char()
end

-- Erase text character by character
local function erase_text(buf, line, callback)
  local current_lines = vim.api.nvim_buf_get_lines(buf, line, line + 1, false)
  if #current_lines == 0 then
    if callback then
      callback()
    end
    return
  end

  local current_text = current_lines[1]
  local len = #current_text

  local function erase_char()
    if len > 0 then
      current_text = current_text:sub(1, len - 1)
      vim.api.nvim_buf_set_option(buf, "modifiable", true)
      vim.api.nvim_buf_set_lines(buf, line, line + 1, false, { current_text })
      vim.api.nvim_buf_set_option(buf, "modifiable", false)
      len = len - 1
      vim.defer_fn(erase_char, config.erase_speed)
    else
      if callback then
        vim.defer_fn(callback, 200)
      end
    end
  end

  erase_char()
end

-- Main animation sequence
local function run_animation(buf, win)
  local current_line = 5 -- Start closer to top since no header
  local message_index = 1

  local function show_next_message()
    if message_index <= #messages then
      local message = messages[message_index]

      type_text(buf, current_line, message, function()
        if message_index < #messages then
          -- Erase current message and show next
          erase_text(buf, current_line, function()
            message_index = message_index + 1
            show_next_message()
          end)
        else
          -- Last message, wait then close
          vim.defer_fn(function()
            if vim.api.nvim_win_is_valid(win) then
              vim.api.nvim_win_close(win, true)
            end
          end, 2000)
        end
      end)
    end
  end

  show_next_message()
end

-- Add green color scheme
local function setup_colors(buf)
  -- Create highlight group for green text
  vim.api.nvim_set_hl(0, "HackerGreen", { fg = "#00ff41", bold = true })

  -- Set the buffer to use green text
  vim.api.nvim_buf_set_option(buf, "modifiable", true)
  vim.api.nvim_buf_call(buf, function()
    vim.cmd("syntax clear")
    vim.cmd("highlight Normal ctermfg=46 guifg=#00ff41")
  end)
  vim.api.nvim_buf_set_option(buf, "modifiable", false)

  -- Hide cursor completely
  vim.cmd("highlight Cursor blend=100")
  vim.cmd("set guicursor=a:block-Cursor/lCursor-blinkon0")
end

-- Main function to start the intro
function M.show_intro()
  -- Only show on startup with no arguments
  if vim.fn.argc() > 0 then
    return
  end

  local buf, win = create_intro_window()

  -- Setup green color scheme
  setup_colors(buf)

  -- Set up key mapping to skip intro
  vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", "", {
    callback = function()
      if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, true)
      end
    end,
    noremap = true,
    silent = true,
  })

  vim.api.nvim_buf_set_keymap(buf, "n", "q", "", {
    callback = function()
      if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, true)
      end
    end,
    noremap = true,
    silent = true,
  })

  -- Start animation after a short delay
  vim.defer_fn(function()
    if vim.api.nvim_win_is_valid(win) then
      run_animation(buf, win)
    end
  end, 500)
end

-- Auto command to show intro on VimEnter
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- Small delay to ensure everything is loaded
    vim.defer_fn(M.show_intro, 100)
  end,
})

return M
