require("globals")

return {
  "andythigpen/nvim-coverage",
  version = "*",
  enabled = Is_enabled("nvim-coverage"),
  event = LoadOnBuffer,
  config = function()
    require("coverage").setup({
      commands = true,
      auto_reload = true,
    })
  end,
}
