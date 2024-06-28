require("globals")

local plugin = "no-clown-fiesta"

return {
  -- dir = "~/code/github/" .. plugin .. ".nvim",
  -- "koenverburg/" .. plugin .. ".nvim",
  "aktersnurra/"
    .. plugin
    .. ".nvim",
  enabled = Is_enabled(plugin),
  lazy = false,
  opts = {
    transparent = false, -- Enable this to disable the bg color
    styles = {
      -- You can set any of the style values specified for `:h nvim_set_hl`
      comments = {},
      keywords = {},
      functions = {},
      variables = {},
      type = { bold = true },
      lsp = { underline = true },
    },
  },
  config = function(_, opts)
    require("no-clown-fiesta").setup(opts)
    vim.cmd([[colorscheme no-clown-fiesta]])
    -- vim.api.nvim_set_hl(0, "StatusLine", { bg = "#151515" })
    -- vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "#151515" })
    -- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    -- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
  end,
}
