return {
  "mcauley-penney/visual-whitespace.nvim",
  enabled = true,
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
