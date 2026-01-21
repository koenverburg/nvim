local ls = require("luasnip")

ls.config.set_config({
  history = true,
  updateevents = "TextChanged,TextChangedI",
  enable_autosnippets = true,
})

vim.keymap.set({ "i", "s" }, "<C-k>", function()
  if ls.expand_or_jumpable() then ls.expand_or_jump() end
end)

vim.keymap.set({ "i", "s" }, "<C-j>", function()
  if ls.jumpable(-1) then ls.jump(-1) end
end)
