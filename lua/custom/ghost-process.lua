local M = {
  commands = {},
}

function M.setup(opts)
  M.commands = opts.commands or {}

  vim.api.nvim_create_user_command("RunCommand", function(args)
    local name = args.args
    local cmd = M.commands[name]

    if not cmd then
      print("No command found: " .. name)
      return
    end

    M.run_command(name, cmd)
  end, {
    nargs = 1,
    complete = function()
      return vim.tbl_keys(M.commands)
    end,
  })
end

function M.run_command(name, command)
  local stdout = vim.loop.new_pipe(false)
  local stderr = vim.loop.new_pipe(false)
  local output = {}

  local handle
  handle = vim.loop.spawn("sh", {
    args = { "-c", command },
    stdio = { nil, stdout, stderr },
  }, function(code, signal)
    stdout:close()
    stderr:close()
    handle:close()

    vim.schedule(function()
      -- Show output in new split
      vim.cmd("botright split")
      vim.cmd("enew")
      vim.bo.buftype = "nofile"
      vim.bo.bufhidden = "wipe"
      vim.bo.swapfile = false
      vim.api.nvim_buf_set_lines(0, 0, -1, false, output)
      vim.api.nvim_buf_set_lines(0, -1, -1, false, {
        "",
        string.format("Command '%s' exited with code %d", name, code),
      })
    end)
  end)

  -- Collect stdout and stderr
  stdout:read_start(function(err, data)
    if err then
      table.insert(output, "ERR: " .. err)
    end
    if data then
      for line in data:gmatch("[^\r\n]+") do
        table.insert(output, line)
      end
    end
  end)

  stderr:read_start(function(err, data)
    if err then
      table.insert(output, "ERR: " .. err)
    end
    if data then
      for line in data:gmatch("[^\r\n]+") do
        table.insert(output, "STDERR: " .. line)
      end
    end
  end)
end

M.setup({
  commands = {
    Format = "prettier --write %",
    Build = "tsc",
    Lint = "eslint %",
  },
})

vim.keymap.set("n", "<leader>gpf", ":RunCommand Format<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>gpl", ":RunCommand Lint<CR>", { noremap = true, silent = true })

return M
