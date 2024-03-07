require('globals')

return {
  -- dir = "~/code/github/complexity.nvim",
  "koenverburg/complexity.nvim",
  event = LoadOnBuffer,
  enabled = Is_enabled("complexity"),
  config = function()
    require('complexity').setup()
  end,
}
