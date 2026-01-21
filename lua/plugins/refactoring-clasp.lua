return {
  "xzbdmw/clasp.nvim",
  lazy = false,
  enabled = true,
  config = function()
    require("clasp").setup({
      pairs = { ["{"] = "}", ["\""] = "\"", ["'"] = "'", ["("] = ")", ["["] = "]", ["<"] = ">" },
      keep_insert_mode = true,
      remove_pattern = nil,
    })

    vim.keymap.set({ "n", "i" }, "<c-l>", function()
      require("clasp").wrap("next")
    end)

    vim.keymap.set({ "n", "i" }, "<c-;>", function()
      require("clasp").wrap("prev")
    end)

    vim.keymap.set({ "n", "i" }, "<c-l>", function()
      if
        vim.fn.mode() == "i"
        and package.loaded["multicursor-nvim"]
        and require("multicursor-nvim").numCursors() > 1
      then
        vim.cmd("stopinsert")
      else
        require("clasp").wrap("next")
      end
    end)
  end,
}
