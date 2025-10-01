require("globals")

return {
  "folke/persistence.nvim",
  enabled = true,
  event = "BufReadPre",
  keys = {
    {
      "<leader>qs",
      function()
        require("persistence").load()
      end,
      desc = "load the session for the current directory",
    },

    {
      "<leader>qS",
      function()
        require("persistence").select()
      end,
      desc = "select a session to load",
    },

    {
      "<leader>ql",
      function()
        require("persistence").load({ last = true })
      end,
      desc = "load the last session",
    },

    {
      "<leader>qd",
      function()
        require("persistence").stop()
      end,
      desc = "stop Persistence => session won't be saved on exit",
    },
  },
  opts = {
    dir = vim.fn.stdpath("state") .. "/sessions/", -- directory where session files are saved
    -- minimum number of file buffers that need to be open to save
    -- Set to 0 to always save
    need = 2,
    branch = true, -- use git branch to save session
  },
}
