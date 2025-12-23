---@type LazySpec
return {
  "rgroli/other.nvim",
  cmd = { "Other", "OtherClear", "OtherSplit", "OtherVSplit" },
  keys = {
    { "<leader><TAB>", "<cmd>Other<CR>" },
    { "soo", "<cmd>Other<CR>" },
    { "sov", "<cmd>OtherVSplit<CR>" },
    { "sos", "<cmd>OtherSplit<CR>" },
  },
  opts = {
    mappings = {
      -- builtin mappings
      "golang",
      "python",
      -- "react",
      "rust",
      {
        pattern = "(.*).([tj]sx?)$",
        target = "%1.spec.%2",
        context = "spec",
      },
      {
        pattern = "(.*).spec.([tj]sx?)$",
        target = "%1.%2",
        context = "implementation",
      },
    },
    -- transformers = {
    -- 	-- remove `server` from the path
    -- 	remove_server = function(inputString)
    -- 		return inputString:gsub("server", "")
    -- 	end,
    -- 	-- add `server` to the path
    -- 	-- ex: +page.ts -> +page.server.ts
    -- 	-- ex: +page.js -> +page.server.js
    -- 	add_server = function(inputString)
    -- 		return inputString:gsub("%.(ts|js)$", ".server.%1")
    -- 	end,
    -- },
  },
  config = function(_, opt)
    require("other-nvim").setup(opt)
  end,
}
