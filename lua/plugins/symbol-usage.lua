require("globals")

return {
  "Wansmer/symbol-usage.nvim",
  enabled = Is_enabled("symbol-usage"),
  event = "LspAttach",
  config = function()
    require("symbol-usage").setup({
      vt_position = 'above',
      -- vt_position = 'end_of_line',
      references = { enabled = true, include_declaration = false },
      definition = { enabled = true },
      implementation = { enabled = true },
    })
  end,
}
