require('globals')
local on_attach = require('core.functions').on_attach

local signs = require("core.config").diagnosticSigns

local function apply_signs()
  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end
end


-- local plugin = "lsp"

local servers = {
  vimls = {},
  dockerls = {},
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
  tsserver = {
    root_dir = vim.loop.cwd,
    disable_formatting = true,
    settings = {
      javascript = {
        inlayHints = {
          includeInlayParameterNameHints = 'all',
          includeInlayVariableTypeHints = true,
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
          includeInlayParameterNameHints = 'all',
          includeInlayParameterNameHintsWhenArgumentMatchesName = true,

          includeInlayVariableTypeHints = true,
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
  html = { cmd = { "vscode-html-language-server", "--stdio" } },
  -- cssls = { cmd = { "vscode-css-language-server", "--stdio" } },
  biome = {

  }
}

return {
  {
    "neovim/nvim-lspconfig",
    event = LoadOnBuffer,
    lazy = false,
    enabled = Is_enabled("lsp"),
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "dmmulroy/ts-error-translator.nvim"
    },
    config = function()
      local config = {
        signs = { active = signs },
        underline = true,
        severity_sort = true,
        update_in_insert = false,
        virtual_text = false,
        -- virtual_text = { spacing = 4, prefix = "●" },

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
        width = 60
      }
      vim.lsp.handlers["textDocument/hover"] =
          vim.lsp.with(vim.lsp.handlers["textDocument/hover"], handlersOpts)

      vim.lsp.handlers["textDocument/signatureHelp"] =
          vim.lsp.with(vim.lsp.handlers.signature_help, handlersOpts)

      vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
        require("ts-error-translator").translate_diagnostics(err, result, ctx, config)
        vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx, config)
      end

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
    cmd = "Mason",
    enabled = Is_enabled("lsp"),
    -- keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    opts = {
      ensure_installed = {
        "stylua",
        "shellcheck",
        "gopls",
        "cssls",
        "lua_ls",
        "tsserver",
        "dockerls",
        "tailwindcss",
        "yamlls",
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
    end,
  },
}
