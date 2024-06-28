require("globals")

-- local Terminal = require("toggleterm.terminal").Terminal
-- local float = Terminal:new({
--   -- cmd = "lazygit",
--   dir = "git_dir",
--   direction = "float",
--   float_opts = {
--     border = "single",
--   },
--   -- function to run on opening the terminal
--   on_open = function(term)
--     vim.cmd("startinsert!")
--     vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
--   end,
--   -- function to run on closing the terminal
--   on_close = function(term)
--     vim.cmd("startinsert!")
--   end,
-- })
-- float:toggle()

return {
  "akinsho/toggleterm.nvim",
  enabled = Is_enabled("toggleterm"),
  version = "*",
  config = function()
    require("toggleterm").setup()
  end,
  -- opts = {
  --   --[[ things you want to change go here]]
  -- },
}
