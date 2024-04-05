require("globals")

return {
  "WolfeCub/harpeek.nvim",
  enabled = Is_enabled("harpeek"),
  event = { "BufEnter" },
  config = function()
    require("harpeek").open({
      winopts = {
        row = 10,
        col = 10,
        border = "rounded",
      },
    })
  end,
}
