return {
  {
    "mfussenegger/nvim-dap",
    enabled = true,
    lazy = false,
    dependencies = {
      "williamboman/mason.nvim",
      "nvim-neotest/nvim-nio",
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "mxsdev/nvim-dap-vscode-js",
      {
        "microsoft/vscode-js-debug",
        version = "1.x",
        build = "npm i && npm run compile vsDebugServerBundle && mv dist out"
      }
    },
    config = function()
      local dap = require("dap")
      local utils = require("dap.utils")
      local dapui = require("dapui")

      require("dap-vscode-js").setup({
        debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
        adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' },
      })

      require("dapui").setup()

      require("nvim-dap-virtual-text").setup({
        -- This just tries to mitigate the chance that I leak tokens here. Probably won't stop it from happening...
        display_callback = function(variable)
          local name = string.lower(variable.name)
          local value = string.lower(variable.value)
          if name:match "secret" or name:match "api" or value:match "secret" or value:match "api" then
            return "*****"
          end

          if #variable.value > 15 then
            return " " .. string.sub(variable.value, 1, 15) .. "... "
          end

          return " " .. variable.value
        end,
      })

      dap.adapters = {
        ["pwa-node"] = {
          type = "server",
          port = "${port}",
          executable = {
            command = "js-debug-adapter",
            args = {
              "${port}",
            },
          },
        },
        ["nlua"] = function(callback, conf)
          local adapter = {
            type = "server",
            host = conf.host or "127.0.0.1",
            port = conf.port or 8086,
          }
          if conf.start_neovim then
            local dap_run = dap.run
            dap.run = function(c)
              adapter.port = c.port
              adapter.host = c.host
            end
            require("osv").run_this()
            dap.run = dap_run
          end
          callback(adapter)
        end,
      }

      dap.configurations.typescript = {
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          cwd = "${workspaceFolder}",
        },
        {
          type = "pwa-node",
          request = "attach",
          name = "Attach to process ID",
          processId = utils.pick_process,
          cwd = "${workspaceFolder}",
        },
        {
          type = "pwa-chrome",
          request = "launch",
          name = "Launch & Debug Chrome",
          url = function()
            local co = coroutine.running()
            return coroutine.create(function()
              vim.ui.input({
                prompt = "Enter URL: ",
                default = "http://localhost:3000",
              }, function(url)
                if url == nil or url == "" then
                  return
                else
                  coroutine.resume(co, url)
                end
              end)
            end)
          end,
          webRoot = vim.fn.getcwd(),
          protocol = "inspector",
          sourceMaps = true,
          userDataDir = false,
        },
      }

      dap.configurations.lua = {
        {
          type = "nlua",
          request = "attach",
          name = "Run this file",
          start_neovim = {},
        },
        {
          type = "nlua",
          request = "attach",
          name = "Attach to running Neovim instance (port = 8086)",
          port = 8086,
        },
      }

      -- Handled by nvim-dap-go
      -- dap.adapters.go = {
      --   type = "server",
      --   port = "${port}",
      --   executable = {
      --     command = "dlv",
      --     args = { "dap", "-l", "127.0.0.1:${port}" },
      --   },
      -- }

      dap.listeners.after.event_initialized["dapui_config"] = dapui.open
      dap.listeners.before.event_terminated["dapui_config"] = dapui.close
      dap.listeners.before.event_exited["dapui_config"] = dapui.close

      local map = function(keys, func, desc)
        if desc then
          desc = "[D]ebugger: " .. desc
        end
        if keys then
          keys = "<leader>d" .. keys
        end
        vim.keymap.set("n", keys, func, { desc = desc })
      end

      map("c", dap.continue, "[C]ontinue")
      -- TODO: is this really needed?
      -- map("a", function()
      --   require("dap").continue({ before = get_args })
      -- end, "Run with [A]rgs")
      map("i", dap.step_into, "Step [I]nto")
      map("O", dap.step_out, "Step [O]ut")
      map("o", dap.step_over, "Step Over")
      map("C", function()
        require("dap").run_to_cursor()
      end, "Run to [C]ursor")
      map("g", function()
        require("dap").goto_()
      end, "[G]o to line (no execute)")
      map("b", dap.toggle_breakpoint, "Toggle [B]reakpoint")
      map("B", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end, "Set [B]reakpoint")
      map("j", dap.down, "Down")
      map("k", dap.up, "Up")
      map("l", dap.run_last, "Run [L]ast")
      map("p", dap.pause, "Pause")
      map("r", function()
        dap.repl.toggle()
      end, "Toggle REPL")
      map("s", dap.session, "Session")
      map("t", dap.terminate, "Terminate")
      map("w", function()
        require("dap.ui.widgets").hover()
      end, "Widgets")

      map("u", function()
        dapui.toggle({
          -- Always open the nvim dap ui in the default sizes
          reset = true,
        })
      end, "Toggle [U]I")
      map("e", function()
        dapui.eval()
      end, "Eval")
    end,
  },
}
