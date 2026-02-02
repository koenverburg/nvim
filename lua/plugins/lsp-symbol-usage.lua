local SymbolKind = {
  File = 1,
  Module = 2,
  Namespace = 3,
  Package = 4,
  Class = 5,
  Method = 6,
  Property = 7,
  Field = 8,
  Constructor = 9,
  Enum = 10,
  Interface = 11,
  Function = 12,
  Variable = 13,
  Constant = 14,
  String = 15,
  Number = 16,
  Boolean = 17,
  Array = 18,
  Object = 19,
  Key = 20,
  Null = 21,
  EnumMember = 22,
  Struct = 23,
  Event = 24,
  Operator = 25,
  TypeParameter = 26,
}

return {
  "Wansmer/symbol-usage.nvim",
  enabled = true,
  event = "LspAttach",
  config = function()
    require("symbol-usage").setup({
      vt_position = "above",
      references = { enabled = true, include_declaration = false },
      definition = { enabled = true },
      implementation = { enabled = true },
      log = { enabled = true },
      kinds = {
        SymbolKind.Method,
        SymbolKind.Function,
        SymbolKind.Variable,
        SymbolKind.Constant,
        SymbolKind.TypeParameter,

        SymbolKind.Key,
        SymbolKind.Field,
        SymbolKind.Struct,
        SymbolKind.Property,

        SymbolKind.Enum,
        SymbolKind.EnumMember,
      },
      text_format = function(symbol)
        local fragments = {}

        print(getmetatable(symbol))
        -- Indicator that shows if there are any other symbols in the same line
        local stacked_functions = (symbol.stacked_count > 0) and (" | +%s"):format(symbol.stacked_count) or ""

        if symbol.references then
          local usage = symbol.references <= 1 and "usage" or "usages"
          local num = symbol.references == 0 and "no" or symbol.references
          table.insert(fragments, ("%s %s"):format(num, usage))
        end

        if symbol.definition then
          table.insert(fragments, symbol.definition .. " defs")
        end

        if symbol.implementation then
          table.insert(fragments, symbol.implementation .. " impls")
        end

        return table.concat(fragments, ", ") .. stacked_functions
      end,
      disable = {
        cond = {
          function()
            -- disable for all files in node_modules
            return vim.fn.expand("%:p"):find("/node_modules/")
          end,
          function()
            -- disable for all files outside of the cwd
            return vim.fn.expand("%:p"):find(vim.fn.getcwd())
          end,
        },
      },
    })
  end,
}
