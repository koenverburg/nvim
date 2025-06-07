require("globals")

return {
  "lukas-reineke/indent-blankline.nvim",
  enabled = Is_enabled("indent-blankline"),
  event = { "BufReadPre", "BufNewFile" },
  lazy = true,
  main = "ibl",
  opts = {
    indent = {
      priority = 1,
      smart_indent_cap = true,
    },
    scope = {
      show_start = true,
      show_end = true,
    },
  },
}
