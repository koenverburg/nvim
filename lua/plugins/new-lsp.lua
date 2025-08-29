local methods = vim.lsp.protocol.Methods
-- local on_attach = require("core.functions").on_attach
-- local signs = require("core.config").diagnosticSigns

local M = {}

-- Disable inlay hints initially (and enable if needed with my ToggleInlayHints command).
vim.g.inlay_hints = false

--- Sets up LSP keymaps and autocommands for the given buffer.
---@param client vim.lsp.Client
---@param bufnr integer
local function on_attach(client, bufnr)
  ---@param lhs string
  ---@param rhs string|function
  ---@param desc string
  ---@param mode? string|string[]
  local function keymap(lhs, rhs, desc, mode)
    mode = mode or "n"
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
  end

  keymap("[d", function()
    vim.diagnostic.jump({ count = -1 })
  end, "Previous diagnostic")
  keymap("]d", function()
    vim.diagnostic.jump({ count = 1 })
  end, "Next diagnostic")
  keymap("[e", function()
    vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR })
  end, "Previous error")
  keymap("]e", function()
    vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR })
  end, "Next error")

  if client:supports_method(methods.textDocument_definition) then
    keymap("gd", function()
      require("fzf-lua").lsp_definitions({ jump1 = true })
    end, "Go to definition")
    keymap("gD", function()
      require("fzf-lua").lsp_definitions({ jump1 = false })
    end, "Peek definition")
  end

  if client:supports_method(methods.textDocument_signatureHelp) then
    local blink_window = require("blink.cmp.completion.windows.menu")
    local blink = require("blink.cmp")

    keymap("<C-k>", function()
      -- Close the completion menu first (if open).
      if blink_window.win:is_open() then
        blink.hide()
      end

      vim.lsp.buf.signature_help()
    end, "Signature help", "i")
  end

  if client:supports_method(methods.textDocument_documentHighlight) then
    local under_cursor_highlights_group = vim.api.nvim_create_augroup("mariasolos/cursor_highlights", { clear = false })
    vim.api.nvim_create_autocmd({ "CursorHold", "InsertLeave" }, {
      group = under_cursor_highlights_group,
      desc = "Highlight references under the cursor",
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter", "BufLeave" }, {
      group = under_cursor_highlights_group,
      desc = "Clear highlight references",
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })
  end

  if client:supports_method(methods.textDocument_inlayHint) and vim.g.inlay_hints then
    local inlay_hints_group = vim.api.nvim_create_augroup("mariasolos/toggle_inlay_hints", { clear = false })

    -- Initial inlay hint display.
    -- Idk why but without the delay inlay hints aren't displayed at the very start.
    vim.defer_fn(function()
      local mode = vim.api.nvim_get_mode().mode
      vim.lsp.inlay_hint.enable(mode == "n" or mode == "v", { bufnr = bufnr })
    end, 500)

    vim.api.nvim_create_autocmd("InsertEnter", {
      group = inlay_hints_group,
      desc = "Enable inlay hints",
      buffer = bufnr,
      callback = function()
        if vim.g.inlay_hints then
          vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
        end
      end,
    })

    vim.api.nvim_create_autocmd("InsertLeave", {
      group = inlay_hints_group,
      desc = "Disable inlay hints",
      buffer = bufnr,
      callback = function()
        if vim.g.inlay_hints then
          vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end
      end,
    })
  end
end

-- Override the virtual text diagnostic handler so that the most severe diagnostic is shown first.
-- local show_handler = vim.diagnostic.handlers.virtual_text.show
-- local hide_handler = vim.diagnostic.handlers.virtual_text.hide

-- assert(show_handler)

-- vim.diagnostic.handlers.virtual_text = {
--   show = function(ns, bufnr, diagnostics, opts)
--     table.sort(diagnostics, function(diag1, diag2)
--       return diag1.severity > diag2.severity
--     end)
--     return custom.render_diagnostics(bufnr, diagnostics)
--     -- return show_handler(ns, bufnr, diagnostics, opts)
--   end,
--   hide = function(_, bufnr)
--     vim.api.nvim_buf_clear_namespace(bufnr, custom.ns, 0, -1)
--     hide_handler(_, bufnr)
--   end,
-- }

local hover = vim.lsp.buf.hover
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.buf.hover = function()
  return hover({
    max_height = math.floor(vim.o.lines * 0.5),
    max_width = math.floor(vim.o.columns * 0.4),
  })
end

local signature_help = vim.lsp.buf.signature_help
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.buf.signature_help = function()
  return signature_help({
    max_height = math.floor(vim.o.lines * 0.5),
    max_width = math.floor(vim.o.columns * 0.4),
  })
end

--- HACK: Override `vim.lsp.util.stylize_markdown` to use Treesitter.
---@param bufnr integer
---@param contents string[]
---@param opts table
---@return string[]
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.util.stylize_markdown = function(bufnr, contents, opts)
  contents = vim.lsp.util._normalize_markdown(contents, {
    width = vim.lsp.util._make_floating_popup_size(contents, opts),
  })
  vim.bo[bufnr].filetype = "markdown"
  vim.treesitter.start(bufnr)
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, contents)

  return contents
end

-- Update mappings when registering dynamic capabilities.
-- local register_capability = vim.lsp.handlers[methods.client_registerCapability]
-- vim.lsp.handlers[methods.client_registerCapability] = function(err, res, ctx)
--     local client = vim.lsp.get_client_by_id(ctx.client_id)
--     if not client then
--         return
--     end

--     on_attach(client, vim.api.nvim_get_current_buf())

--     return register_capability(err, res, ctx)
-- end

-- vim.api.nvim_create_autocmd('LspAttach', {
--     desc = 'Configure LSP keymaps',
--     callback = function(args)
--         local client = vim.lsp.get_client_by_id(args.data.client_id)

--         -- I don't think this can happen but it's a wild world out there.
--         if not client then
--             return
--         end

--         on_attach(client, args.buf)
--     end,
-- })

--- Configures the given server with its settings and applying the regular
--- client capabilities (+ the completion ones from blink.cmp).
---@param server string
---@param settings? table
function M.configure_server(server, settings)
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)

  require("lspconfig")[server].setup(
    vim.tbl_deep_extend("error", { capabilities = capabilities, silent = true }, settings or {})
  )
end

return {
  "neovim/nvim-lspconfig",
  dependencies = { "saghen/blink.cmp" },

  enabled = true,
  -- example using `opts` for defining servers
  opts = {
    servers = {
      lua_ls = {},
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
      },
    },
  },
  config = function(_, opts)
    local lspconfig = require("lspconfig")
    for server, config in pairs(opts.servers) do
      -- passing config.capabilities to blink.cmp merges with the capabilities in your
      -- `opts[server].capabilities, if you've defined it
      -- config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
      -- config.on_attach = on_attach
      lspconfig[server].setup(config)
    end
  end,
}

-- example calling setup directly for each LSP
-- config = function()
--   local capabilities = require('blink.cmp').get_lsp_capabilities()
--   local lspconfig = require('lspconfig')
--   lspconfig['lua_ls'].setup({ capabilities = capabilities })
-- end
