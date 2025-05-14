require("globals")
local on_attach = require("core.functions").on_attach
local signs = require("core.config").diagnosticSigns
local icons = require("core.config").signs

local methods = vim.lsp.protocol.Methods

local function apply_signs()
  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end
end

-- local plugin = "lsp"

local servers = {
  dockerls = {},
  pyright = {},
  lua_ls = {
    settings = {
      Lua = {
        diagnostics = {
          globals = { "vim" },
        },
        hint = { enable = true },
      },
    },
  },
  yamlls = {
    settings = {
      yaml = {
        schemas = { kubernetes = "globPattern" },
      },
    },
  },
  gopls = {
    settings = {
      gopls = {
        hints = {
          constantValues = true,
          parameterNames = true,
          rangeVariableTypes = true,
          assignVariableTypes = true,
          compositeLiteralTypes = true,
          compositeLiteralFields = true,
          functionTypeParameters = true,
        },
      },
    },
  },
  ts_ls = {
    root_dir = vim.loop.cwd,
    disable_formatting = true,
    settings = {
      javascript = {
        inlayHints = {
          includeInlayParameterNameHints = "all",
          includeInlayVariableTypeHints = false,
          includeInlayEnumMemberValueHints = true,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayVariableTypeHintsWhenTypeMatchesName = false,
          includeInlayParameterNameHintsWhenArgumentMatchesName = true,
        },
      },
      typescript = {
        inlayHints = {
          includeInlayParameterNameHints = "all",
          includeInlayParameterNameHintsWhenArgumentMatchesName = true,

          includeInlayVariableTypeHints = false,
          includeInlayVariableTypeHintsWhenTypeMatchesName = false,

          includeInlayFunctionParameterTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,

          includeInlayEnumMemberValueHints = true,

          includeInlayPropertyDeclarationTypeHints = true,
        },
      },
    },
    filetypes = {
      "javascript",
      "javascriptreact",
      "javascript.jsx",

      "typescript",
      "typescriptreact",
      "typescript.tsx",
    },
  },
  -- html = { cmd = { "vscode-html-language-server", "--stdio" } },
  -- cssls = { cmd = { "vscode-css-language-server", "--stdio" } },
  biome = {},
}

return {
  {
    "neovim/nvim-lspconfig",
    event = LoadOnBuffer,
    lazy = false,
    enabled = false, -- Is_enabled("lsp"),
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "dmmulroy/ts-error-translator.nvim",
    },
    config = function()
      local config = {
        signs = { active = signs },
        underline = true,
        severity_sort = true,
        update_in_insert = true,
        virtual_lines = false,
        virtual_text = {
          current_line = true,
        },

        float = {
          focusable = false,
          style = "minimal",
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
      }

      apply_signs()
      vim.diagnostic.config(config)
      local handlersOpts = {
        -- border = "rounded",
        width = 60,
      }

      -- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers["textDocument/hover"], handlersOpts)

      -- vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, handlersOpts)

      -- Workaround for truncating long TypeScript inlay hints.
      -- TODO: Remove this if https://github.com/neovim/neovim/issues/27240 gets addressed.
      -- local inlay_hint_handler = vim.lsp.handlers[methods.textDocument_inlayHint]
      -- vim.lsp.handlers[methods.textDocument_inlayHint] = function(err, result, ctx, config)
      --   local client = vim.lsp.get_client_by_id(ctx.client_id)
      --   if client and client.name == "typescript-tools" then
      --     result = vim.iter.map(function(hint)
      --       local label = hint.label ---@type string
      --       if label:len() >= 30 then
      --         label = label:sub(1, 29) .. icons.ellipsis
      --       end
      --       hint.label = label
      --       return hint
      --     end, result)
      --   end

      --   inlay_hint_handler(err, result, ctx, config)
      -- end

      -- vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
      --   require("ts-error-translator").translate_diagnostics(err, result, ctx, config)
      --   vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx, config)
      -- end

      local lspconfig = require("lspconfig")

      for name, opts in pairs(servers) do
        if type(opts) == "function" then
          opts()
        else
          local client = lspconfig[name]
          client.setup(vim.tbl_extend("force", {
            -- inlay_hints = { enabled = true },
            on_attach = on_attach,
            flags = { debounce_text_changes = 150 },
          }, opts))
        end
      end
    end,
  },
  {
    "williamboman/mason.nvim",
    event = LoadOnBuffer,
    -- cmd = "Mason",
    lazy = false,
    enabled = Is_enabled("lsp"),
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    opts = {
      ensure_installed = {
        "stylua",
        "shellcheck",
        "gopls",
        "cssls",
        "ts_ls",
        "dockerls",
        "tailwindcss",
        "yamlls",
        "rust_analyzer",
        "lua-language-server",
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
    end,
  },
}
