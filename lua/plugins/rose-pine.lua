require("globals")

return {
  "rose-pine/neovim",
  name = "rose-pine",
  enabled = Is_enabled("rose-pine"),
  lazy = false,
  config = function()
    require("rose-pine").setup({
      variant = "moon", -- auto, main, moon, or dawn
      dark_variant = "moon", -- main, moon, or dawn
    })

    vim.cmd("colorscheme rose-pine")
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
  end,
}
