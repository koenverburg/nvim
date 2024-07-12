require("globals")

return {
  "Fildo7525/pretty_hover",
  event = "LspAttach",
  enabled = Is_enabled("comment"),
  config = function()
    require("pretty_hover").setup({
      max_width = 100,
    })
  end,
}
