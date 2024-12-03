require("globals")

return {
  {
    "WolfeCub/harpeek.nvim",
    -- dir = "~/code/github/harpeek.nvim",
    enabled = false, --  Is_enabled("harpeek"),
    event = { "BufEnter" },
    config = function()
      require("harpeek").open({
        winopts = {
          row = 10,
          col = 10,
          border = "rounded",
        },
      })
    end,
  },
  {
    "otavioschwanck/arrow.nvim",
    enabled = false and Is_enabled("harpeek"),
    event = LoadOnBuffer,
    opts = {
      show_icons = true,
      leader_key = ",", -- Recommended to be a single key
      buffer_leader_key = "m", -- Per Buffer Mappings
    },
    config = function(_, opts)
      require("arrow").setup(opts)
      vim.keymap.set("n", "<leader>ap", require("arrow.persist").previous)
      vim.keymap.set("n", "<leader>l", require("arrow.persist").next)
      vim.keymap.set("n", "<C-s>", require("arrow.persist").toggle)
    end,
  },
}
