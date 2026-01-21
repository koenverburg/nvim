return {
  "ecthelionvi/NeoColumn.nvim",
  enabled = true,
  event = "BufReadPost",
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
