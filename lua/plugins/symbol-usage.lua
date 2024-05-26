require("globals")
return {
  "Wansmer/symbol-usage.nvim",
  enabled = Is_enabled("symbol-usage"),
  event = "BufReadPre", -- need run before LspAttach if you use nvim 0.9. On 0.10 use 'LspAttach'
  config = function()
    require("symbol-usage").setup()
  end,
}
