require("globals")

return {
    "soemre/commentless.nvim",
    cmd = "Commentless",
    enabled = Is_enabled('commentless'),
    keys = {
        {
            "<leader>/",
            function()
                require("commentless").toggle()
            end,
            desc = "Toggle Comments",
        },
    },
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
    },
    opts = {
        hide_following_blank_lines = true,
        foldtext = function(folded_count)
            return "(" .. folded_count .. " comments)"
        end,
    },
}
