require("globals")

return {
  "tpope/vim-repeat",
  "junegunn/vim-easy-align",
  "nvim-tree/nvim-web-devicons",
  "antoinemadec/FixCursorHold.nvim",
  "prisma/vim-prisma",
  -- { "typicode/bg.nvim", lazy = false },
  {
    "mcauley-penney/tidy.nvim",
    event = LoadOnBuffer,
    config = true,
  },
}
