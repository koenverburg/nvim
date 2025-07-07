local M = {}

-- Comment patterns for different file types
local comment_patterns = {
  -- Languages with # comments
  lua = { prefix = "--", char = "-" },
  python = { prefix = "# ", char = "-" },
  bash = { prefix = "# ", char = "-" },
  shell = { prefix = "# ", char = "-" },
  sh = { prefix = "# ", char = "-" },
  zsh = { prefix = "# ", char = "-" },
  ruby = { prefix = "# ", char = "-" },
  perl = { prefix = "# ", char = "-" },
  yaml = { prefix = "# ", char = "-" },
  yml = { prefix = "# ", char = "-" },
  toml = { prefix = "# ", char = "-" },
  conf = { prefix = "# ", char = "-" },
  config = { prefix = "# ", char = "-" },
  ini = { prefix = "# ", char = "-" },

  -- Languages with // comments
  typescript = { prefix = "// ", char = "-" },
  javascript = { prefix = "// ", char = "-" },
  rust = { prefix = "// ", char = "-" },
  go = { prefix = "// ", char = "-" },
  c = { prefix = "// ", char = "-" },
  cpp = { prefix = "// ", char = "-" },
  java = { prefix = "// ", char = "-" },
  kotlin = { prefix = "// ", char = "-" },
  swift = { prefix = "// ", char = "-" },
  dart = { prefix = "// ", char = "-" },
  php = { prefix = "// ", char = "-" },

  -- SQL
  sql = { prefix = "-- ", char = "-" },

  -- HTML/XML
  html = { prefix = "<!-- ", suffix = " -->", char = "-" },
  xml = { prefix = "<!-- ", suffix = " -->", char = "-" },

  -- CSS
  css = { prefix = "/* ", suffix = " */", char = "-" },
  scss = { prefix = "/* ", suffix = " */", char = "-" },
  sass = { prefix = "/* ", suffix = " */", char = "-" },
  less = { prefix = "/* ", suffix = " */", char = "-" },
}

-- Comment styles
local comment_styles = {
  minimal = "minimal",
  normal = "normal",
  solid = "solid",
  normal_center = "normal_center"
}

-- Get the appropriate comment pattern for current buffer
local function get_comment_pattern()
  local filetype = vim.bo.filetype
  local pattern = comment_patterns[filetype]

  -- Fallback for unknown filetypes - try to detect from file extension
  if not pattern then
    local filename = vim.fn.expand("%:t")
    local ext = filename:match("%.([^%.]+)$")
    if ext then
      pattern = comment_patterns[ext:lower()]
    end
  end

  -- Default fallback
  if not pattern then
    pattern = { prefix = "# ", char = "-" }
  end

  return pattern
end

-- Generate the section comment based on style
local function generate_section_comment(section_name, pattern, style)
  local total_width = 80 -- Total width of the comment section
  local prefix_width = #pattern.prefix
  local suffix_width = pattern.suffix and #pattern.suffix or 0
  local available_width = total_width - prefix_width - suffix_width

  local lines = {}
  local dashes = string.rep(pattern.char, available_width)

  if style == comment_styles.minimal then
    local name_with_spaces = " --- " .. section_name .. " "
    local remaining_dashes = string.rep(pattern.char, available_width - #name_with_spaces)
    table.insert(lines, pattern.prefix .. name_with_spaces .. remaining_dashes .. (pattern.suffix or ""))

  elseif style == comment_styles.normal then
    table.insert(lines, pattern.prefix .. dashes .. (pattern.suffix or ""))
    table.insert(lines, pattern.prefix .. section_name .. (pattern.suffix or ""))
    table.insert(lines, pattern.prefix .. dashes .. (pattern.suffix or ""))

  elseif style == comment_styles.solid then
    table.insert(lines, pattern.prefix .. dashes .. (pattern.suffix or ""))
    local name_with_spaces = " " .. section_name .. " "
    local name_width = #name_with_spaces
    local side_dashes = string.rep(pattern.char, math.floor((available_width - name_width) / 2))
    table.insert(lines, pattern.prefix .. side_dashes .. name_with_spaces .. side_dashes .. (pattern.suffix or ""))
    table.insert(lines, pattern.prefix .. dashes .. (pattern.suffix or ""))

  elseif style == comment_styles.normal_center then
    table.insert(lines, pattern.prefix .. dashes .. (pattern.suffix or ""))
    local name_with_spaces = section_name
    local side_dashes = string.rep(" ", math.floor((available_width - #name_with_spaces) / 2))
    table.insert(lines, pattern.prefix .. side_dashes .. name_with_spaces .. side_dashes .. (pattern.suffix or ""))
    table.insert(lines, pattern.prefix .. dashes .. (pattern.suffix or ""))
  end

  return lines
end

-- Main function to create section comment
function M.create_section_comment()
  -- Get current cursor position
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))

  -- Prompt for section name
  vim.ui.input({ prompt = "Section name: " }, function(input)
    if not input or input == "" then
      return
    end

    -- Prompt for comment style
    vim.ui.select(
      { comment_styles.minimal, comment_styles.normal, comment_styles.solid, comment_styles.normal_center },
      { prompt = "Select comment style:" },
      function(style)
        if not style then
          return
        end

        local pattern = get_comment_pattern()
        local lines = generate_section_comment(input, pattern, style)

        -- Insert the lines at current cursor position
        vim.api.nvim_buf_set_lines(0, row - 1, row - 1, false, lines)

        -- Move cursor to after the inserted lines
        vim.api.nvim_win_set_cursor(0, { row + #lines, 0 })
      end
    )
  end)
end

-- Setup function to create the command
function M.setup(opts)
  opts = opts or {}

  -- Create user command
  vim.api.nvim_create_user_command("SectionComment", M.create_section_comment, {
    desc = "Create a section comment with custom name",
  })

  -- Optional: Create a keymap if specified in opts
  if opts.keymap then
    vim.keymap.set("n", opts.keymap, M.create_section_comment, {
      desc = "Create section comment",
      silent = true,
    })
  end
end

return M
