require("globals")

return {
  "junegunn/vim-easy-align",
  enabled = Is_enabled("easy-align"),
  lazy = false,
  keys = {
    { "ga", "<Plug>(EasyAlign)", desc = "EaslyAgain" },
  },
}
