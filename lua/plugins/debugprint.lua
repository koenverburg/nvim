require("globals")

return {
  "andrewferrier/debugprint.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  enabled = Is_enabled("debugprint"),
  event = LoadOnBuffer,
  opts = {
    keymaps = {
      normal = {
        plain_below = "ds",
        variable_below = "dp",

        delete_debug_prints = "dP",
        -- defaults below
        plain_above = "g?P",
        variable_above = "g?V",
        variable_below_alwaysprompt = nil,
        variable_above_alwaysprompt = nil,
        textobj_below = "g?o",
        textobj_above = "g?O",
        toggle_comment_debug_prints = nil,
      },
      visual = {
        variable_below = "g?v",
        variable_above = "g?V",
      },
    },
    -- commands = {
    --   toggle_comment_debug_prints = "ToggleCommentDebugPrints",
    --   delete_debug_prints = "DeleteDebugPrints",
    -- },
  },
}
