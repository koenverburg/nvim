require("globals")

return {
  "kylechui/nvim-surround",
  enabled = Is_enabled("nvim-surround"),
  version = "*", -- Use for stability; omit to use `main` branch for the latest features
  event = "VeryLazy",
  config = function()
    require("nvim-surround").setup({
      -- Configuration here, or leave empty to use defaults
    })
    vim.go.operatorfunc = "v:lua.require'nvim-surround'.normal_callback"
  end,
}
