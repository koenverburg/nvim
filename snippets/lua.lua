local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.add_snippets("lua", {
  -- Module
  s("lmod", {
    t("local M = {}"),
    t({ "", "", "function M." }), i(1, "setup"), t("()"),
    t({ "", "  " }), i(2),
    t({ "", "end", "", "return M" }),
  }),

  -- Require
  s("lreq", {
    t("local "), i(1, "mod"), t(" = require('"), i(2), t("')"),
  }),

  -- Autocmd
  s("autocmd", {
    t("vim.api.nvim_create_autocmd('"), i(1, "BufWritePost"), t("', {"),
    t({ "", "  callback = function()" }),
    t({ "", "    " }), i(2),
    t({ "", "  end" }),
    t({ "", "})" }),
  }),
})
