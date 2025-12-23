local keymaps = require("core.keymaps")

return {
  "nvim-telescope/telescope.nvim",
  enabled = true,
  lazy = true,
  event = LoadOnBuffer,
  keys = keymaps.get_plugin_keys("telescope"),
  dependencies = {
    "nvim-lua/popup.nvim",
    "nvim-lua/plenary.nvim",
    "FabianWirth/search.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    {
      "ray-x/telescope-ast-grep.nvim",
      opts = {},
    },
  },
  config = function()
    require("2_plugin-configs.telescope")
  end,
}
