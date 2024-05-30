require("globals")

return {
  "koenverburg/cmd-palette.nvim",
  enabled = Is_enabled("cmd-palette"),
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
        label = "Term",
        callback = function()
          local Terminal = require("toggleterm.terminal").Terminal
          local lazygit = Terminal:new({
            cmd = "lazygit",
            dir = "git_dir",
            direction = "float",
            float_opts = {
              border = "double",
            },
            -- function to run on opening the terminal
            on_open = function(term)
              vim.cmd("startinsert!")
              vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
            end,
            -- function to run on closing the terminal
            on_close = function(term)
              vim.cmd("startinsert!")
            end,
          })
          lazygit:toggle()
        end,
      },
    })
  end,
}
