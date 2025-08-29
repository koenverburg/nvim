require("globals")

return {
  "rmagatti/goto-preview",
  dependencies = { "rmagatti/logger.nvim" },
  enabled = Is_enabled("goto-preview"),
  event = LoadOnBuffer,
  config = true, -- necessary as per https://github.com/rmagatti/goto-preview/issues/88
  keys = {
    {
      "gpd",
      "<cmd>lua require('goto-preview').goto_preview_definition()<CR>",
      desc = "preview definition",
      noremap = true
    },
    {
      "gpt",
      "<cmd>lua require('goto-preview').goto_preview_type_definition()<CR>",
      desc = "preview type definition",
      noremap = true
    },
    {
      "gpi",
      "<cmd>lua require('goto-preview').goto_preview_implementation()<CR>",
      desc = "preview implementation",
      noremap = true
    },
    {
      "gpD",
      "<cmd>lua require('goto-preview').goto_preview_declaration()<CR>",
      desc = "preview declaration",
      noremap = true
    },
    {
      "gP",
      "<cmd>lua require('goto-preview').close_all_win({ skip_curr_window = true })<CR>",
      desc = "close all preview windows",
      noremap = true
    },
    {
      "gpr",
      "<cmd>lua require('goto-preview').goto_preview_references()<CR>",
      desc = "preview references",
      noremap = true
    }
  }
}
