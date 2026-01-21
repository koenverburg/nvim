return {
  "andythigpen/nvim-coverage",
  version = "*",
  enabled = true,
  cmd = {
    "Coverage",
  },
  -- event = LoadOnBuffer,
  lazy = true,
  config = function()
    require("coverage").setup({
      commands = true,
      auto_reload = true,
    })
  end,
}
