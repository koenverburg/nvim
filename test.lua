local ns_id = vim.api.nvim_create_namespace("my_overlay")
local ns = vim.api.nvim_create_namespace("indented_virtual_text")

-- Clear existing virtual text
vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)

-- Add virtual text to multiple consecutive lines
local overlay_text = {
  "First line of overlay",
  "Second line of overlay",
  "Third line of overlay",
}

local function render_virtual_breakdown(items, highlight, start_line, column)
  local count = #items

  vim.api.nvim_buf_set_extmark(0, ns_id, start_line - 1, 0, {
    virt_text = { { "─┬─ " .. items[1], highlight } },
    -- virt_text_pos = "overlay",
    virt_text_win_col = column,
  })

  for i = 2, count do
    if i ~= count then
      vim.api.nvim_buf_set_extmark(0, ns_id, start_line + i - 2, 0, {
        virt_text = { { " ├─ " .. items[i], highlight } },
        virt_text_pos = "overlay",
        virt_text_win_col = column,
      })
    elseif i == count then
      vim.api.nvim_buf_set_extmark(0, ns_id, start_line + i - 2, 0, {
        virt_text = { { " ╰─ " .. items[i], highlight } },
        virt_text_pos = "overlay",
        virt_text_win_col = column,
      })
    end
  end
end

render_virtual_breakdown(overlay_text, "Comment", 15, 80)
