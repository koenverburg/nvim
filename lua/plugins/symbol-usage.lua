require("globals")

return {
  "Wansmer/symbol-usage.nvim",
  enabled = Is_enabled("symbol-usage"),
  event = "LspAttach",
  config = function()
    require("symbol-usage").setup()
  end,
}
