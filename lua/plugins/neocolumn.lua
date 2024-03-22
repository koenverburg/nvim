require("globals")

return {
  "ecthelionvi/NeoColumn.nvim",
  enabled = Is_enabled("neocolumn"),
  event = LoadOnBuffer,
  lazy = false,
  opts = {
    NeoColumn = "100",
    always_on = true,
    custom_NeoColumn = {},
    excluded_ft = { "text", "markdown" },
  },
  config = function(_, opts)
    require("NeoColumn").setup(opts)
  end,
}
