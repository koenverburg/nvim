local signs = require("core.config").diagnosticSigns

local diagnostic_config = {
  [vim.diagnostic.severity.ERROR] = { hl = "DiagnosticSignError", icon = "" },
  [vim.diagnostic.severity.WARN] = { hl = "DiagnosticSignWarn", icon = "" },
  [vim.diagnostic.severity.INFO] = { hl = "DiagnosticSignInfo", icon = "" },
  [vim.diagnostic.severity.HINT] = { hl = "DiagnosticSignHint", icon = "" },
}

local config = {
  signs = { active = signs },
  underline = true,
  severity_sort = true,
  update_in_insert = true,

  virtual_lines = false,

  virtual_text = false,
  --   {
  --   current_line = true,
  -- },

  -- float = {
  --   focusable = false,
  --   style = "minimal",
  --   border = "rounded",
  --   source = "always",
  --   header = "",
  --   prefix = "",
  -- },
}

local function apply_signs()
  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end
end

return {
  -- "rachartier/tiny-inline-diagnostic.nvim",
  dir = "~/code/github/tiny-inline-diagnostic.nvim",
  enabled = false,
  event = "VeryLazy", -- Or `LspAttach`
  priority = 1000, -- needs to be loaded in first
  config = function()
    require("tiny-inline-diagnostic").setup({
      preset = "classic",

      transparent_bg = true, -- Set the background of the diagnostic to transparent
      transparent_cursorline = true, -- Set the background of the cursorline to transparent (only one the first diagnostic)

      options = {
        show_source = {
          enabled = true,
          if_many = true,
        },

        -- Set the arrow icon to the same color as the first diagnostic severity
        set_arrow_to_diag_color = false,
        use_icons_from_diagnostic = false,
        show_all_diags_on_cursorline = true,

        format = function(diagnostic)
          -- print(vim.inspect(diagnostic))
          return diagnostic_config[diagnostic.severity].icon .. " " .. diagnostic.message
          -- return diagnostic.message .. " [" .. diagnostic.source .. "]"
        end,

        overflow = {
          -- Manage how diagnostic messages handle overflow
          -- Options:
          -- "wrap" - Split long messages into multiple lines
          -- "none" - Do not truncate messages
          -- "oneline" - Keep the message on a single line, even if it's long
          mode = "none",

          -- Trigger wrapping to occur this many characters earlier when mode == "wrap".
          -- Increase this value appropriately if you notice that the last few characters
          -- of wrapped diagnostics are sometimes obscured.
          padding = 0,
        },
      },
      signs = {
        left = "─┬─",
        right = "",
        diag = "├─",
        -- diag = "─┬─",
        arrow = "───────",
        up_arrow = "    ",
        vertical = "├─",
        vertical_end = "╰─",
      },
    })
    apply_signs()
    vim.diagnostic.config(config) -- Only if needed in your configuration, if you already have native LSP diagnostics
  end,
}
