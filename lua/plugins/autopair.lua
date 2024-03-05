require("globals")

return {
  'altermo/ultimate-autopair.nvim',
  enabled = Is_enabled("autopair"),
  event = { 'InsertEnter', 'CmdlineEnter' },
  branch = 'v0.6',
  opts = {},
}
