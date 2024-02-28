require('globals')

local plugin = "no-clown-fiesta"

return {
  "aktersnurra/" .. plugin .. ".nvim",
  enabled = Is_enabled(plugin),
  lazy    = false,
  opts    = {
    transparent = false, -- Enable this to disable the bg color
    styles = {
      -- You can set any of the style values specified for `:h nvim_set_hl`
      comments = {},
      keywords = {},
      functions = {},
      variables = {},
      type = { bold = true },
      lsp = { underline = true }
    },
  },
  config  = function(_, opts)
    require("no-clown-fiesta").setup(opts)
    vim.cmd[[colorscheme no-clown-fiesta]]
  end,
}
