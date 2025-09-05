require("globals")

return {
  'Wansmer/treesj',
  keys = { '<space>m', '<space>j', '<space>s' },
  enabled = Is_enabled("treesj"),
  -- event = LoadOnBuffer,
  dependencies = { 'nvim-treesitter/nvim-treesitter' }, -- if you install parsers with `nvim-treesitter`
  config = function()
    require('treesj').setup()
  end,
}
