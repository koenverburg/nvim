return {
  "Wansmer/symbol-usage.nvim",
  enabled = true,
  event = "LspAttach",
  config = function()
    require("symbol-usage").setup({
      vt_position = "above",
      -- vt_position = 'end_of_line',
      references = { enabled = true, include_declaration = false },
      definition = { enabled = true },
      implementation = { enabled = true },
    })
  end,
}
