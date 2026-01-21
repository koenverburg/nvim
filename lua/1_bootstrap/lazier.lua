local function echo(message, hl)
    vim.api.nvim_echo({{ message, hl or "Normal" }}, true, {})
end

local function bootstrap(author, name, opts)
    opts = opts or {}
    local path = opts.dir or (
        vim.fn.stdpath("data") .. "/" .. name .. "/" .. name .. ".nvim"
    )

    if not vim.uv.fs_stat(path) then
        local repo = "https://github.com/" .. author .. "/" .. name .. ".nvim"
        local out = vim.fn.system({
            "git",
            "clone",
            "--branch=" .. (opts.branch or "stable"),
            "--filter=blob:none",
            repo,
            path
        })
        if vim.v.shell_error ~= 0 then
            echo("Failed to clone " .. name .. ":", "Error")
            echo(out)
            vim.fn.getchar()
            os.exit(1)
        end
    end
    vim.opt.runtimepath:prepend(path)
end

bootstrap("jake-stewart", "lazier", {
    branch = "stable-v2"
})

bootstrap("folke", "lazy", {
    branch = "main"
    -- spec = {
    --   { import = "plugins" },
    --   { import = "plugins/navigation" },
    --   { import = "plugins/themes" },
    --   { import = "plugins/ui" },
    --   { import = "plugins/dap" },
    --   { import = "plugins/personal" },
    --   { import = "plugins/simplicity" },
    -- },

    -- rocks = {
    --   enabled = false,
    -- },

    -- defaults = {
    --   lazy = true,
    --   version = false,
    -- },

    -- checker = { enabled = true, notify = false },

    -- performance = {
    --   cache = {
    --     enabled = true,
    --   },
    --   rtp = {
    --     disabled_plugins = {
    --       "gzip",
    --       "tar",
    --       "tarPlugin",
    --       "matchit",
    --       "matchparen",
    --       "netrwPlugin",
    --       "tohtml",
    --       "tutor",
    --       "zip",
    --       "zipPlugin",
    --       "netrw",
    --       "netrwPlugin",
    --       "netrwSettings",
    --       "netrwFileHandlers",
    --     },
    --   },
    -- },
})

require("lazier").setup("plugins", {
    -- spec = {
    --   { import = "plugins" },
    -- },
    lazier = {
        before = function()
            -- vim.loader.enable()
            require("0_internal.constants")
            require("0_internal.qof-commands")
            require("core.options")
            require("core.commands")
            require("core.remaps")
            require("custom.quick-actions")
            require("core.autocmds")
            -- function to run before the ui renders.
            -- it is faster to require parts of your config here
            -- since at this point they will be bundled and bytecode compiled.
            -- eg: require("options")
        end,

        -- after = function()
        --     -- function to run after the ui renders.
        --     -- eg: require("mappings")
        -- end,

        -- start_lazily = function ()
        --     return false
        -- end,

        -- start_lazily = function()
        --     -- function which returns whether lazy.nvim
        --     -- should start delayed or not.
        --     local nonLazyLoadableExtensions = {
        --         zip = true,
        --         tar = true,
        --         gz = true
        --     }

        --     local fname = vim.fn.expand("%")

        --     return fname == ""
        --         or vim.fn.isdirectory(fname) == 0
        --         and not nonLazyLoadableExtensions
        --             [vim.fn.fnamemodify(fname, ":e")]
        -- end,

        -- whether to bundle & byte code compile parts of the
        -- neovim lua api. this can be a boolean or custom list of modules.
        compile_api = true,

        -- whether plugins should be included in the bytecode
        -- compiled bundle. this will make your startup slower.
        bundle_plugins = true,

        -- whether to automatically generate lazy loading config
        -- by identifying the mappings set when the plugin loads
        generate_lazy_mappings = true,

        -- automatically rebundle and compile nvim config when it changes
        -- if set to false then you will need to :LazierClear manually
        detect_changes = true,
    },
    defaults = { lazy = true },
    -- install = {
    --     colorscheme = { "no-clown-fiesta" }
    -- },
    change_detection = {
        enabled = false,
        notify = false
    },
    performance = {
        cache = { enabled = true },
        reset_packpath = true,
        rtp = {
            reset = false,
            disabled_plugins = {
                "tohtml",
                "tutor",
            }
        }
    }

    -- your usual lazy.nvim config goes here
    -- ...
})
