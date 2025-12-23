return {
  "nvim-mini/mini.indentscope",
  version = "*",
  enabled = true,
  event = LoadOnBuffer,
  init = function()
    vim.api.nvim_create_autocmd("FileType", {
      desc = "Disable indentscope for certain filetypes",
      pattern = {
        "help",
        "Trouble",
        "trouble",
        "lazy",
        "mason",
        "notify",
        "better_term",
        "toggleterm",
        "lazyterm",
      },
      callback = function()
        vim.b.miniindentscope_disable = true
      end,
    })
  end,
  config = function()
    require("mini.indentscope").setup({
      draw = {
        delay = 300,
      },
      symbol = "│",
    })
    vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", { link = "comment" })
  end,
}
