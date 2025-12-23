return {
  "L3MON4D3/LuaSnip",
  event = LoadOnBuffer,
  enabled = false,
  dependencies = {
    "saadparwaiz1/cmp_luasnip",
    "rafamadriz/friendly-snippets",
  },
  config = function()
    local ls = require("luasnip")

    ls.config.set_config({
      history = false,
      updateevents = "TextChanged,TextChangedI",
    })

    local parse = require("luasnip.util.parser").parse_snippet
    local s = require("luasnip.nodes.snippet").S
    local p = require("luasnip.extras").partial

    s("date", p(os.date, "%Y-%m-%d"))
    s("time", p(os.date, "%H:%M"))
    -- s("time2", p(os.date, "%Y-%m-%dT%H:%M:%S+10:00"))

    require("luasnip.loaders.from_vscode").lazy_load()
  end,
}
