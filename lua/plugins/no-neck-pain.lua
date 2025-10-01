require("globals")

return {
  "shortcuts/no-neck-pain.nvim",
  version = "*",
  enabled = Is_enabled("no-neck-pain"),
  cmd = "NoNeckPain",
  opts = {
    width = 200,
  },
  config = function(_, opts)
    require("no-neck-pain").setup(opts)
  end,
}
