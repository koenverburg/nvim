return {
  "m4xshen/autoclose.nvim",
  enabled = true,
  event = "InsertEnter",
  config = function()
    require("autoclose").setup({
      keys = {
        ["("] = { escape = false, close = true, pair = "()" },
        ["["] = { escape = false, close = true, pair = "[]" },
        ["{"] = { escape = false, close = true, pair = "{}" },

        [">"] = { escape = true, close = false, pair = "<>" },
        [")"] = { escape = true, close = false, pair = "()" },
        ["]"] = { escape = true, close = false, pair = "[]" },
        ["}"] = { escape = true, close = false, pair = "{}" },

        ["\""] = { escape = true, close = true, pair = "\"\"" },
        ["'"] = { escape = true, close = true, pair = "''" },
        ["`"] = { escape = true, close = true, pair = "``" },
      },
      options = {
        disabled_filetypes = { "text" }, -- File types this plugin is disabled for.
        disable_when_touch = false, -- Disable the auto-close function when the cursor touches character that matches touch_regex.
        touch_regex = "[%w(%[{]",
        pair_spaces = true, -- Pair the spaces when cursor is inside a pair of keys.
        auto_indent = true, -- Enable auto-indent feature.
        disable_command_mode = false, -- Disable autoclose for command mode globally.
      },
    })
  end,
}
