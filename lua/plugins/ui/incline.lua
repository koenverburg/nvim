return {
  "b0o/incline.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  enabled = true,
  event = LoadOnBuffer,
  config = function()
    local devicons = require("nvim-web-devicons")

    local git_helpers = require("logic.git")
    local diagnostic_helpers = require("logic.diagnostic")

    require("incline").setup({
      window = {
        padding = 0,
        margin = { horizontal = 0 },
      },
      render = function(props)
        local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
        if filename == "" then
          filename = "[No Name]"
        end

        local editor_bg = "#151515"
        local ft_icon, ft_color = devicons.get_icon_color(filename)
        local modified = vim.bo[props.buf].modified

        local function get_git_diff()
          local diff = git_helpers.get_diff_from_buffer(props.buf)

          local has_changes = diff.added ~= 0 or diff.removed ~= 0 or diff.changed ~= 0

          if not has_changes then
            return {}
          end

          local labels = {}

          table.insert(labels, { "(", group = "Comment" })

          if diff.added and diff.added > 0 then
            table.insert(labels, { git_helpers.icons.added .. diff.added, group = "Comment" })
          end

          if diff.removed > 0 then
            table.insert(labels, { git_helpers.icons.removed .. diff.removed, group = "Comment" })
          end

          if diff.changed > 0 then
            table.insert(labels, { git_helpers.icons.changed .. diff.changed, group = "Comment" })
          end

          table.insert(labels, { ")", group = "Comment" })
          table.insert(labels, { " " })

          return labels
        end

        local function get_diagnostic_label()
          local label = {}

          local stats = diagnostic_helpers.get_diagnostics_from_buffer(props.buf)

          if stats.info > 0 then
            table.insert(
              label,
              { diagnostic_helpers.icons.info .. " " .. stats.info .. " ", group = "DiagnosticSignInfo" }
            )
          end

          if stats.hints > 0 then
            table.insert(
              label,
              { diagnostic_helpers.icons.hint .. " " .. stats.hints .. " ", group = "DiagnosticSignHint" }
            )
          end

          if stats.warnings > 0 then
            table.insert(
              label,
              { diagnostic_helpers.icons.warn .. " " .. stats.warnings .. " ", group = "DiagnosticSignWarn" }
            )
          end

          if stats.errors > 0 then
            table.insert(
              label,
              { diagnostic_helpers.icons.error .. " " .. stats.errors .. " ", group = "DiagnosticSignError" }
            )
          end

          if #label > 0 then
            table.insert(label, { " " })
          end

          return label
        end

        return {
          { get_git_diff() },
          { get_diagnostic_label() },
          { filename, gui = modified and "bold,italic" or "bold" },
          ft_icon and {
            " ",
            ft_icon,
            guifg = ft_color,
            guibg = editor_bg,
          } or "",
          " ",
          guibg = editor_bg,
        }
      end,
    })
  end,
}
