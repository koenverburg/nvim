return {
  "echasnovski/mini.clue",
  enabled = true,
  event = "VeryLazy",
  config = function()
    local miniclue = require("mini.clue")
    miniclue.setup({
      triggers = {
        { mode = "n", keys = "<Leader>" },
        { mode = "x", keys = "<Leader>" },
        { mode = "n", keys = "<Space>" },
        { mode = "x", keys = "<Space>" },
        { mode = "n", keys = "g" },
        { mode = "x", keys = "g" },
        { mode = "n", keys = "z" },
        { mode = "x", keys = "z" },
        { mode = "n", keys = "<C-w>" },
      },
      clues = {
        miniclue.gen_clues.builtin_completion(),
        miniclue.gen_clues.g(),
        miniclue.gen_clues.marks(),
        miniclue.gen_clues.registers(),
        miniclue.gen_clues.windows(),
        miniclue.gen_clues.z(),

        { mode = "n", keys = "<Leader>f", desc = "+file" },
        { mode = "n", keys = "<Leader>b", desc = "+buffer" },
        { mode = "n", keys = "<Leader>w", desc = "+window" },
        { mode = "n", keys = "<Leader>s", desc = "+split" },
        { mode = "n", keys = "<Leader>t", desc = "+tab" },
        { mode = "n", keys = "<Leader>g", desc = "+git" },
        { mode = "n", keys = "<Leader>l", desc = "+lsp" },
        { mode = "n", keys = "<Leader>d", desc = "+diagnostics" },
        { mode = "n", keys = "<Leader>c", desc = "+code" },
        { mode = "n", keys = "<Leader>j", desc = "+jump" },
        { mode = "n", keys = "<Space>f", desc = "+find" },
      },
      window = { delay = 300, config = { border = "rounded" } },
    })
  end,
}
