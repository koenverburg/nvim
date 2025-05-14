require("globals")

return {
  "nguyenvukhang/nvim-toggler",
  enabled = Is_enabled("nvim-toggler"),
  event = LoadOnBuffer,
  lazy = false,
  keys = {
    { "<leader>ta", "<cmd>lua require('nvim-toggler').toggle()<cr>", desc = "[T]oggle [A]lternative" },
  },
  config = function()
    require("nvim-toggler").setup({
      -- your own inverses
      inverses = {
        ["dev"] = "prod",
        -- ["prod"] = "dev",
        ["development"] = "production",
        -- ["production"] = "development",
        ["live"] = "backtest",
        -- ["backtest"] = "live",
        ["true"] = "false",
        -- ["True"] = "False",
        -- ["TRUE"] = "FALSE",
        ["Yes"] = "No",
        ["YES"] = "NO",
        ["1"] = "0",
        ["<"] = ">",
        ["("] = ")",
        ["["] = "]",
        ["{"] = "}",
        ["\""] = "'",
        ["\"\""] = "''",
        ["+"] = "-",
        ["==="] = "!==",
        ["=="] = "!=",
      },
      remove_default_keybinds = true,
      remove_default_inverses = true,
    })
  end,
}
