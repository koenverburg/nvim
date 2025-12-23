-- local ok, blink = pcall(require, 'blink.cmp')
--
-- local capabilities = {}
--
-- if ok then
-- 	capabilities = blink.get_lsp_capabilities()
-- end

return {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  -- capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
    },
  },
  root_markers = {
    ".luarc.json",
    ".luarc.jsonc",
    ".luacheckrc",
    ".stylua.toml",
    "stylua.toml",
    "selene.toml",
    "selene.yml",
    ".git",
  },
}
