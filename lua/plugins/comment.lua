require("globals")

return {
  "numToStr/Comment.nvim",
  enabled = Is_enabled("comment"),
  event = LoadOnBuffer,
  -- lazy = false,
  config = function()
    require("Comment").setup()
    local comment_ft = require("Comment.ft")
    comment_ft.set("lua", { "--%s", "--[[%s]]" })

    comment_ft.set("json", { "// %s" })
    comment_ft.set("javascriptreact", { "// %s" })
    comment_ft.set("typescriptreact", { "// %s" })
  end,
}
