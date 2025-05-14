require("globals")

return {
  -- "koenverburg/minimal-tabline.nvim",
  branch = "develop",
  event = LoadOnBuffer,
  dir = "~/code/github/minimal-tabline.nvim",
  enabled = Is_enabled("minimal-tabline"),
  lazy = true,
  opts = {
    enabled = true,
    file_name = false,
    tab_index = true,
    pane_count = false,
    modified_sign = true,
    no_name = "[No Name]",
  },
  config = function(_, opts)
    require("minimal-tabline").setup(opts)
    vim.o.showtabline = 1
  end,
}
