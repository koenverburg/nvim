return {
  "rmagatti/goto-preview",
  dependencies = { "rmagatti/logger.nvim" },
  enabled = true,
  event = "LspAttach",
  config = true, -- necessary as per https://github.com/rmagatti/goto-preview/issues/88
  keys = {
    { "gpd", "<cmd>lua require('goto-preview').goto_preview_definition()<cr>", desc = "Preview definition" },
    { "gpi", "<cmd>lua require('goto-preview').goto_preview_implementation()<cr>", desc = "Preview implementation" },
    { "gpt", "<cmd>lua require('goto-preview').goto_preview_type_definition()<cr>", desc = "Preview type definition" },
    { "gpr", "<cmd>lua require('goto-preview').close_all_win()<cr>", desc = "Close all preview windows" },
  },
}
