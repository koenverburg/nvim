require('globals')

return {
  -- dir = "~/code/github/peepsight.nvim",
  "koenverburg/peepsight.nvim",
  branch = "update",
  enabled = Is_enabled("peepsight"),
  cmd = "Peepsight",
  config = function()
    require("peepsight").setup({
      -- markdown
      "paragraph",

      -- go
      "function_declaration",
      "method_declaration",
      "func_literal",

      -- shared
      -- "if_statement", -- go, js, ts

      -- JavaScript / TypeScript
      "class_declaration",
      "method_definition",
      "arrow_function",
      "function_declaration",
      "generator_function_declaration",
    })
  end,
}
