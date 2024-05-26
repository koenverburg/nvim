require("globals")

return {
  "miversen33/sunglasses.nvim",
  enabled = Is_enabled("sunglasses"),
  event = "UIEnter",
  config = true,
  opts = {
    filter_type = "SHADE",
    filter_percent = 0.5,
  },
}
