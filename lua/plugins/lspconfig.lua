require('globals')

local function configure_server(server, settings)
    -- local capabilities = vim.lsp.protocol.make_client_capabilities()
    -- capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)

    vim.lsp.config(server,
        vim.tbl_deep_extend('error', {
            silent = false
            -- on_attach = on_attach,
            -- capabilities = capabilities,
        }, settings or {})
    )

    print('hii', server)

    vim.lsp.enable(server)
end

return {
    {
      "williamboman/mason.nvim",
      event = LoadOnBuffer,
      -- cmd = "Mason",
      lazy = false,
      enabled = true, -- Is_enabled("lsp"),
      keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
      opts = {
        ensure_installed = {
          "vtsls",
          "stylua",
          "shellcheck",
          "gopls",
          "cssls",
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
    {
        'neovim/nvim-lspconfig',
        event = LoadOnBuffer,
        lazy = false,
        enabled = true, --Is_enabled('lsp'),
        dependencies = {
            -- LSP wrapper for vtsls.
            'yioneko/nvim-vtsls',
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
        config = function()
            local lspconfig = require('lspconfig')
            -- require('lspconfig.ui.windows').default_options.border = 'rounded'

            -- local configure_server = require('lsp').configure_server

            -- Servers without extra configuration.
            configure_server('bashls')
            configure_server('cssls')
            configure_server('html')
            configure_server('dockerls')
            configure_server('pyright')

            configure_server('gopls', {
                filetypes = { '.go' },
            })

            configure_server('yamlls', {
                settings = {
                  yaml = {
                    schemas = { kubernetes = "globPattern" },
                  },
                },
            })

            -- configure_server(lspconfig, 'eslint', {
            --     filetypes = {
            --         'javascript',
            --         'javascriptreact',
            --         'typescript',
            --         'typescriptreact',
            --     },
            --     settings = { format = false },
            --     on_attach = function(_, bufnr)
            --         vim.keymap.set(
            --             'n',
            --             '<leader>ce',
            --             '<cmd>EslintFixAll<cr>',
            --             { desc = 'Fix all ESLint errors', buffer = bufnr }
            --         )
            --     end,
            -- })

            -- configure_server(lspconfig, 'ts_ls', {
            --     root_dir = vim.loop.cwd,
            --     disable_formatting = true,
            --     filetypes = {
            --         'javascript',
            --         'javascriptreact',
            --         'typescript',
            --         'typescriptreact',
            --     },
            --     settings = { format = false },
            -- })

            -- configure_server(lspconfig, 'jsonls', {
            --     settings = {
            --         json = {
            --             validate = { enable = true },
            --         },
            --     },
            --     -- Lazy-load schemas.
            --     -- on_new_config = function(config)
            --     --     config.settings.json.schemas = config.settings.json.schemas or {}
            --     --     vim.list_extend(config.settings.json.schemas, require('schemastore').json.schemas())
            --     -- end,
            -- })

            -- configure_server(lspconfig, 'lua_ls', {
            --     ---@param client vim.lsp.Client
            --     on_init = function(client)
            --         local path = client.workspace_folders
            --             and client.workspace_folders[1]
            --             and client.workspace_folders[1].name
            --         if
            --             not path
            --             or not (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
            --         then
            --             client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
            --                 Lua = {
            --                     runtime = {
            --                         version = 'LuaJIT',
            --                     },
            --                     workspace = {
            --                         checkThirdParty = false,
            --                         library = {
            --                             vim.env.VIMRUNTIME,
            --                             '${3rd}/luv/library',
            --                         },
            --                     },
            --                 },
            --             })
            --             client:notify(
            --                 vim.lsp.protocol.Methods.workspace_didChangeConfiguration,
            --                 { settings = client.config.settings }
            --             )
            --         end

            --         return true
            --     end,
            --     settings = {
            --         Lua = {
            --             -- Using stylua for formatting.
            --             format = { enable = false },
            --             hint = {
            --                 enable = true,
            --                 arrayIndex = 'Disable',
            --             },
            --             completion = { callSnippet = 'Replace' },
            --         },
            --     },
            -- })

            -- configure_server('rust_analyzer', {
            --     settings = {
            --         ['rust-analyzer'] = {
            --             inlayHints = {
            --                 -- These are a bit too much.
            --                 chainingHints = { enable = false },
            --             },
            --         },
            --     },
            -- })

            -- Use the same settings for JS and TS.
            local lang_settings = {
                suggest = { completeFunctionCalls = true },
                inlayHints = {
                    functionLikeReturnTypes = { enabled = true },
                    parameterNames = { enabled = 'literals' },
                    variableTypes = { enabled = true },
                },
            }

            configure_server('vtsls', {
                settings = {
                    typescript = lang_settings,
                    javascript = lang_settings,
                    vtsls = {
                        -- Automatically use workspace version of TypeScript lib on startup.
                        autoUseWorkspaceTsdk = true,
                        experimental = {
                            -- Inlay hint truncation.
                            maxInlayHintLength = 30,
                            -- For completion performance.
                            completion = {
                                enableServerSideFuzzyMatch = true,
                            },
                        },
                    },
                },
            })

            -- configure_server('yamlls', {
            --     settings = {
            --         yaml = {
            --             -- Using the schemastore plugin instead.
            --             schemastore = {
            --                 enable = false,
            --                 url = '',
            --             },
            --         },
            --     },
            --     -- Lazy-load schemas.
            --     -- on_new_config = function(config)
            --     --     config.settings.yaml.schemas = config.settings.yaml.schemas or {}
            --     --     vim.list_extend(config.settings.yaml.schemas, require('schemastore').yaml.schemas())
            --     -- end,
            -- })
        end,
    },
}
