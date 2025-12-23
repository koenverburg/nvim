-- Unified keymap system for mini.clue integration
local M = {}

-- Central keymap registry organized by leader key groups
M.keymaps = {
  -- Space-prefixed keymaps (main namespace)
  space = {
    ["<space>fa"] = { "<cmd>Telescope telescope-alternate alternate_file<cr>", "Alternate file" },
    ["<space>ff"] = { "<cmd>Telescope find_files<cr>", "Find files" },
    ["<space>fg"] = { "<cmd>Telescope live_grep<cr>", "Live grep" },
    ["<space>fb"] = { "<cmd>Telescope buffers<cr>", "Find buffers" },
    ["<space>fh"] = { "<cmd>Telescope help_tags<cr>", "Help tags" },
    ["<space>fc"] = { "<cmd>Telescope commands<cr>", "Commands" },
    ["<space>fk"] = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
    ["<space>fs"] = { "<cmd>Telescope grep_string<cr>", "Grep string" },
    ["<space>t"] = { "<cmd>Telescope git_files<cr>", "Git files" },
    ["<space>p"] = {
      function()
        require("telescope.builtin").git_files(
          require("telescope.themes").get_dropdown({ previewer = false, layout_config = { width = 0.6, height = 0.8 } })
        )
      end,
      "Git files (dropdown)",
    },

    -- Folding
    ["<space>f"] = { "za", "Toggle fold" },
    ["<space>"] = { "za", "Toggle fold" },

    -- Splits with telescope
    ["<space>-"] = { "<cmd>split<cr><c-w>j<cmd>Telescope git_files<cr>", "Horizontal split + git files" },
    ["<space>|"] = { "<cmd>vsplit<cr><c-w>l<cmd>Telescope git_files<cr>", "Vertical split + git files" },

    -- Find and replace
    ["<space>fr"] = { ":%s/\\<<C-r><C-w>\\>//g<Left><Left>", "Find and replace word" },

    -- Toggle features
    ["<space>sl"] = { "<cmd>set invlist<cr>", "Toggle listchars" },

    -- Custom experiments
    -- ["<space>ta"] = { "<cmd>lua require('custom.experiments').edit()<cr>", "Toggle test/implementation" },

    -- TreeSJ
    ["<space>m"] = { "<cmd>TSJToggle<cr>", "Toggle split/join" },
    ["<space>j"] = { "<cmd>TSJJoin<cr>", "Join lines" },
    ["<space>s"] = { "<cmd>TSJSplit<cr>", "Split lines" },
  },

  -- Leader-prefixed keymaps (main leader namespace)
  leader = {
    -- Quick actions
    ["<leader>q"] = { "<cmd>lua require('core.functions').quite()<cr>", "Quick quit" },
    ["<leader><space>"] = { "<cmd>nohlsearch<cr>", "Clear search highlight" },
    ["<leader>i"] = {
      function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = vim.api.nvim_get_current_buf() }))
      end,
      "Toggle inlay hints",
    },

    -- File operations
    f = {
      name = "File",
      ["<leader>ff"] = { "<cmd>Telescope find_files<cr>", "Find files" },
      ["<leader>fr"] = { "<cmd>Telescope oldfiles<cr>", "Recent files" },
      ["<leader>fs"] = { "<cmd>write<cr>", "Save file" },
    },

    -- Buffer operations
    b = {
      name = "Buffer",
      ["<leader>bd"] = { "<cmd>bdelete<cr>", "Delete buffer" },
      ["<leader>bn"] = { "<cmd>bnext<cr>", "Next buffer" },
      ["<leader>bp"] = { "<cmd>bprevious<cr>", "Previous buffer" },
    },

    -- Window management
    w = {
      name = "Window",
      ["<leader>wh"] = { "<C-w>h", "Move to left window" },
      ["<leader>wj"] = { "<C-w>j", "Move to bottom window" },
      ["<leader>wk"] = { "<C-w>k", "Move to top window" },
      ["<leader>wl"] = { "<C-w>l", "Move to right window" },
      ["<leader>wv"] = { "<C-w>v", "Split vertically" },
      ["<leader>ws"] = { "<C-w>s", "Split horizontally" },
      ["<leader>we"] = { "<C-w>=", "Equal windows" },
      ["<leader>wx"] = { "<cmd>close<cr>", "Close window" },
    },

    -- Split management (legacy compatibility)
    s = {
      name = "Split",
      ["<leader>sv"] = { "<C-w>v", "Split vertically" },
      ["<leader>sh"] = { "<C-w>s", "Split horizontally" },
      ["<leader>se"] = { "<C-w>=", "Equal splits" },
      ["<leader>sx"] = { "<cmd>close<cr>", "Close split" },
      ["<leader>s"] = { ":'<,'>!sort -f<cr>", "Sort selection", mode = "v" },
    },

    -- Tab management
    t = {
      name = "Tab",
      ["<leader>to"] = { "<cmd>tabnew<cr>", "Open new tab" },
      ["<leader>tx"] = { "<cmd>tabclose<cr>", "Close tab" },
      ["<leader>tn"] = { "<cmd>tabnext<cr>", "Next tab" },
      ["<leader>tp"] = { "<cmd>tabprevious<cr>", "Previous tab" },
      ["<leader>tf"] = { "<cmd>tabnew %<cr>", "Current buffer in new tab" },
      -- ["<leader>t"] = { "<cmd>tabnew<cr><cmd>Telescope git_files<cr>", "New tab with git files" },
      ["<leader>ta"] = { "<cmd>lua require('nvim-toggler').toggle()<cr>", "Toggle alternative" },
    },

    -- Git operations
    g = {
      name = "Git",
      ["<leader>gg"] = { "<cmd>Neogit<cr>", "Neogit" },
      ["<leader>gb"] = { "<cmd>Gitsigns blame_line<cr>", "Blame line" },
      ["<leader>gp"] = { "<cmd>Gitsigns preview_hunk<cr>", "Preview hunk" },
      ["<leader>gr"] = { "<cmd>Gitsigns reset_hunk<cr>", "Reset hunk" },
      ["<leader>gs"] = { "<cmd>Gitsigns stage_hunk<cr>", "Stage hunk" },
      ["<leader>gu"] = { "<cmd>Gitsigns undo_stage_hunk<cr>", "Undo stage hunk" },
    },

    -- LSP operations
    l = {
      name = "LSP",
      ["<leader>la"] = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code actions" },
      ["<leader>ld"] = { "<cmd>lua vim.lsp.buf.definition()<cr>", "Go to definition" },
      ["<leader>lD"] = { "<cmd>lua vim.lsp.buf.declaration()<cr>", "Go to declaration" },
      ["<leader>li"] = { "<cmd>lua vim.lsp.buf.implementation()<cr>", "Go to implementation" },
      ["<leader>lr"] = { "<cmd>lua vim.lsp.buf.references()<cr>", "Show references" },
      ["<leader>lR"] = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename symbol" },
      -- ["<leader>lf"] = { "<cmd>lua vim.lsp.buf.format()<cr>", "Format code" },
      ["<leader>lh"] = { "<cmd>lua vim.lsp.buf.hover()<cr>", "Hover documentation" },
      ["<leader>ls"] = { "<cmd>lua vim.lsp.buf.signature_help()<cr>", "Signature help" },
    },

    -- Diagnostics
    d = {
      name = "Diagnostics",
      ["<leader>dd"] = { "<cmd>lua vim.diagnostic.open_float()<cr>", "Show line diagnostics" },
      ["<leader>dn"] = { "<cmd>lua vim.diagnostic.goto_next()<cr>", "Next diagnostic" },
      ["<leader>dp"] = { "<cmd>lua vim.diagnostic.goto_prev()<cr>", "Previous diagnostic" },
      ["<leader>dl"] = { "<cmd>lua vim.diagnostic.setloclist()<cr>", "Diagnostics to location list" },
      ["<leader>dq"] = { "<cmd>lua vim.diagnostic.setqflist()<cr>", "Diagnostics to quickfix" },
      ["<leader>dr"] = { "<cmd>lua vim.diagnostic.reset()<cr>", "Reset diagnostics" },
      ["<leader>de"] = {
        "<cmd>lua vim.diagnostic.goto_next({severity = vim.diagnostic.severity.ERROR})<cr>",
        "Next error",
      },
      ["<leader>dw"] = {
        "<cmd>lua vim.diagnostic.goto_next({severity = vim.diagnostic.severity.WARN})<cr>",
        "Next warning",
      },
    },

    -- Jump/Navigation
    j = {
      name = "Jump",
      ["<leader>jf"] = { "<cmd>HopWordMW<cr>", "Jump to word" },
      ["<leader>jl"] = { "<cmd>HopLineStart<cr>", "Jump to line" },
      ["<leader>jc"] = { "<cmd>HopChar1<cr>", "Jump to character" },
    },

    -- Toggle operations
    ["<leader>ta"] = { "<cmd>lua require('nvim-toggler').toggle()<cr>", "Toggle alternative" },

    -- Special combinations
    ["<leader><leader>f"] = { "<cmd>lua require('custom.experiments').fold()<cr>", "Fold experiments" },
    ["<leader><leader>x"] = { "<cmd>lua require('core.functions').save_and_execute()<cr>", "Save and execute" },
  },

  -- Direct keymaps (no prefix)
  direct = {
    -- Basic movement improvements
    ["H"] = { "^", "Go to first non-blank character" },
    ["L"] = { "g_", "Go to last non-blank character" },
    ["Y"] = { "y$", "Yank to end of line" },
    ["J"] = { "mzJ`z", "Join lines and restore cursor" },
    ["G"] = { "Gzz", "Go to end and center" },

    -- Search improvements
    ["n"] = { "nzzzv", "Next search result (centered)" },
    ["N"] = { "Nzzzv", "Previous search result (centered)" },

    -- Command mode improvements
    [";"] = { ":", "Command mode" },
    [":"] = { ";", "Repeat f/t motion" },

    -- Bracket jumping
    ["<Tab>"] = { "%", "Jump to matching bracket" },

    -- Splits
    ["-"] = { "<cmd>split<cr><C-w>j", "Horizontal split and move down" },
    ["|"] = { "<cmd>vsplit<cr><C-w>l", "Vertical split and move right" },

    -- Tab navigation
    ["<S-Tab>"] = { "<cmd>tabnext<cr>", "Next tab" },

    -- Fold shortcuts
    ["of"] = { "za", "Open/close fold" },

    -- Quick escape
    ["jk"] = { "<Esc>", "Exit insert mode", mode = "i" },
    ["jj"] = { "<Esc>", "Exit insert mode", mode = "i" },
    ["kk"] = { "<Esc>", "Exit insert mode", mode = "i" },

    -- Undo break points
    [","] = { ",<C-g>u", "Insert comma with undo break", mode = "i" },
    ["."] = { ".<C-g>u", "Insert period with undo break", mode = "i" },

    -- Window movement
    ["<C-h>"] = { "<C-w>h", "Move to left window" },
    ["<C-j>"] = { "<C-w>j", "Move to bottom window" },
    ["<C-k>"] = { "<C-w>k", "Move to top window" },
    ["<C-l>"] = { "<C-w>l", "Move to right window" },

    -- Resize windows
    ["<M-,>"] = { "<C-w>5<", "Decrease width" },
    ["<M-.>"] = { "<C-w>5>", "Increase width" },
    ["<M-t>"] = { "<C-W>+", "Increase height" },
    ["<M-s>"] = { "<C-W>-", "Decrease height" },

    -- Visual mode improvements
    ["<"] = { "<gv", "Indent left and reselect", mode = "v" },
    [">"] = { ">gv", "Indent right and reselect", mode = "v" },

    -- LSP direct bindings
    ["gd"] = { "<cmd>lua vim.lsp.buf.definition()<cr>", "Go to definition" },
    ["gD"] = { "<cmd>lua vim.lsp.buf.declaration()<cr>", "Go to declaration" },
    ["gi"] = { "<cmd>lua vim.lsp.buf.implementation()<cr>", "Go to implementation" },
    -- ["gr"] = { "<cmd>lua vim.lsp.buf.references()<cr>", "Show references" },
    ["K"] = { "<cmd>lua vim.lsp.buf.hover()<cr>", "Hover documentation" },
    ["[d"] = { "<cmd>lua vim.diagnostic.goto_prev()<cr>", "Previous diagnostic" },
    ["]d"] = { "<cmd>lua vim.diagnostic.goto_next()<cr>", "Next diagnostic" },

    -- Git hunks
    ["]c"] = { "<cmd>Gitsigns next_hunk<cr>", "Next git hunk" },
    ["[c"] = { "<cmd>Gitsigns prev_hunk<cr>", "Previous git hunk" },

    -- Special keys
    ["<C-P>"] = { "<cmd>CmdPalette<cr>", "Command palette" },
    -- ["<C-b>"] = { "<cmd>NvimTreeToggle<cr>", "Toggle file tree" },

    -- Plugin-specific
    ["ga"] = { "<Plug>(EasyAlign)", "Easy align" },
    ["gpd"] = { "<cmd>lua require('goto-preview').goto_preview_definition()<cr>", "Preview definition" },
    ["gpi"] = { "<cmd>lua require('goto-preview').goto_preview_implementation()<cr>", "Preview implementation" },
    ["gpr"] = { "<cmd>lua require('goto-preview').goto_preview_references()<cr>", "Preview references" },
    ["gP"] = { "<cmd>lua require('goto-preview').close_all_win()<cr>", "Close all preview windows" },

    -- Disable unwanted keys
    ["q"] = { "<NOP>", "Disable macro recording" },
  },

  -- Special plugin keys that need exact format for lazy.nvim
  plugin_keys = {
    telescope = {
      "<space>fa",
      "<space>ff",
      "<space>t",
      "<space>p",
      "<space>gs",
      "<c-p>",
    },
    hop = {
      { "<leader>jf", "<cmd>HopWordMW<cr>", desc = "[W]ord [J]ump" },
    },
    goto_preview = {
      { "gpd", "<cmd>lua require('goto-preview').goto_preview_definition()<cr>", desc = "Preview definition" },
      { "gpi", "<cmd>lua require('goto-preview').goto_preview_implementation()<cr>", desc = "Preview implementation" },
      { "gpr", "<cmd>lua require('goto-preview').goto_preview_references()<cr>", desc = "Preview references" },
      { "gP", "<cmd>lua require('goto-preview').close_all_win()<cr>", desc = "Close all preview windows" },
    },
    nvim_toggler = {
      { "<leader>ta", "<cmd>lua require('nvim-toggler').toggle()<cr>", desc = "Toggle alternative" },
    },
    treesj = {
      "<space>m",
      "<space>j",
      "<space>s",
    },
    commentless = {
      {
        "<leader>/",
        function()
          require("commentless").toggle()
        end,
        desc = "Toggle comments",
      },
    },
  },
}

-- Generate mini.clue configuration
function M.get_miniclue_clues()
  local clues = {}

  -- Add leader-based clues
  for group_name, group_config in pairs(M.keymaps.leader) do
    if type(group_config) == "table" and group_config.name then
      -- This is a group
      for key, mapping in pairs(group_config) do
        if key ~= "name" and type(mapping) == "table" then
          table.insert(clues, {
            mode = mapping.mode or "n",
            keys = key,
            desc = mapping[2] or "Unknown",
          })
        end
      end
    elseif type(group_config) == "table" and group_config[1] then
      -- This is a direct mapping
      table.insert(clues, {
        mode = group_config.mode or "n",
        keys = group_name,
        desc = group_config[2] or "Unknown",
      })
    end
  end

  -- Add space-based clues
  for key, mapping in pairs(M.keymaps.space) do
    if type(mapping) == "table" and mapping[1] then
      table.insert(clues, {
        mode = mapping.mode or "n",
        keys = key,
        desc = mapping[2] or "Unknown",
      })
    end
  end

  -- Add direct clues
  for key, mapping in pairs(M.keymaps.direct) do
    if type(mapping) == "table" and mapping[1] then
      table.insert(clues, {
        mode = mapping.mode or "n",
        keys = key,
        desc = mapping[2] or "Unknown",
      })
    end
  end

  return clues
end

-- Set up all keymaps
function M.setup()
  -- Set up direct keymaps
  for key, mapping in pairs(M.keymaps.direct) do
    if type(mapping) == "table" and mapping[1] then
      local mode = mapping.mode or "n"
      local rhs = mapping[1]
      local desc = mapping[2]
      vim.keymap.set(mode, key, rhs, { desc = desc, noremap = true, silent = true })
    end
  end

  -- Set up space keymaps
  for key, mapping in pairs(M.keymaps.space) do
    if type(mapping) == "table" and mapping[1] then
      local mode = mapping.mode or "n"
      local rhs = mapping[1]
      local desc = mapping[2]
      vim.keymap.set(mode, key, rhs, { desc = desc, noremap = true, silent = true })
    end
  end

  -- Set up leader keymaps
  for group_key, group_config in pairs(M.keymaps.leader) do
    if type(group_config) == "table" then
      if group_config.name then
        -- This is a group, set up individual mappings
        for key, mapping in pairs(group_config) do
          if key ~= "name" and type(mapping) == "table" and mapping[1] then
            local mode = mapping.mode or "n"
            local rhs = mapping[1]
            local desc = mapping[2]
            vim.keymap.set(mode, key, rhs, { desc = desc, noremap = true, silent = true })
          end
        end
      elseif group_config[1] then
        -- This is a direct mapping
        local mode = group_config.mode or "n"
        local rhs = group_config[1]
        local desc = group_config[2]
        vim.keymap.set(mode, group_key, rhs, { desc = desc, noremap = true, silent = true })
      end
    end
  end
end

function M.get_plugin_keys(plugin_name)
  return M.keymaps.plugin_keys[plugin_name] or {}
end

return M
