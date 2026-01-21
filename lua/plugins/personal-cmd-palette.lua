return {
  "koenverburg/cmd-palette.nvim",
  enabled = true,
  cmd = "CmdPalette",
  config = function()
    require("cmd-palette").setup({
      { label = "Peepsight", cmd = "Peepsight" },
      {
        label = "reset",
        callback = function()
          vim.cmd([[ set number ]])
          vim.o.signcolumn = "yes"
        end,
      },
      {
        label = "blackout",
        callback = function()
          vim.cmd([[ colorscheme quiet ]])
          vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE" })
          vim.api.nvim_set_hl(0, "Keyword", { bold = true })
          vim.api.nvim_set_hl(0, "Comment", { italic = true })
          vim.api.nvim_set_hl(0, "Constant", { fg = "#999999" })
          vim.api.nvim_set_hl(0, "NormalFloat", { fg = "#333333" })
        end,
      },
      {
        label = "telescope - filter - Payments",
        callback = function()
          require("custom.experiments").filter_for("payment")
        end,
      },
      {
        label = "telescope - filter - Payments widget",
        callback = function()
          require("custom.experiments").filter_for("payment widget")
        end,
      },
      {
        label = "telescope - filter - widget",
        callback = function()
          require("custom.experiments").filter_for("widget")
        end,
      },
      {
        label = "telescope - filter - nvim",
        callback = function()
          require("custom.experiments").filter_for("nvim")
        end,
      },
      {
        label = "telescope - filter - typescript",
        callback = function()
          require("custom.experiments").filter_for(".ts")
        end,
      },
      {
        label = "telescope - filter - lua",
        callback = function()
          require("custom.experiments").filter_for(".lua")
        end,
      },
      {
        label = "conceal",
        callback = function()
          if vim.o.conceallevel > 0 then
            vim.o.conceallevel = 0
          else
            vim.o.conceallevel = 2
          end
        end,
      },
      {
        label = "Edit in new tab",
        callback = function()
          vim.cmd(":tabedit %|tabprev|:q")
        end,
      },
      {
        label = "Disable inlay Hints",
        cmd = function()
          vim.lsp.inlay_hint.enable(nil, { bufnr = 0 })
        end,
      },
    })
  end,
}
