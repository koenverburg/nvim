require("globals")

return {
  "echasnovski/mini.hipatterns",
  enabled = Is_enabled("mini-hipatterns"),
  lazy = false,
  config = function()
    local hipatterns = require("mini.hipatterns")
    hipatterns.setup({
      highlighters = {
        -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
        fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "DiagnosticSignError" },
        hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "DiagnosticSignWarn" },
        todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "DiagnosticSignHint" },
        note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "DiagnosticSignInfo" },

        -- Highlight hex color strings (`#rrggbb`) using that color
        hex_color = hipatterns.gen_highlighter.hex_color(),
      },
    })
  end,
}
