return {
  "prisma/vim-prisma",
  "nvim-tree/nvim-web-devicons",
  { "antoinemadec/FixCursorHold.nvim", lazy = true},
  { "nvim-lua/plenary.nvim", lazy = true },
  {
    "mcauley-penney/tidy.nvim",
    event = LoadOnBuffer,
    config = true,
  },
}
