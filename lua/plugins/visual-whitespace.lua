require("globals")

return {
  "mcauley-penney/visual-whitespace.nvim",
  enabled = Is_enabled("visual-whitespace"),
  event = LoadOnBuffer,
  config = true,
  opts = {
    highlight = { link = "Visual" },
    space_char = "·",
    tab_char = "→",
    nl_char = "↲",
    cr_char = "←",
  },
}
