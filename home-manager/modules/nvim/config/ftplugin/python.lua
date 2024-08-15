local dap = require("dap")
local dappy = require("dap-python")
local root_dir = vim.fs.root(0, { "setup.py", "setup.cfg", "pyproject.toml", ".git" })
if root_dir then
  local folders = { ".venv" }
  for _, folder in ipairs(folders) do
    local path = root_dir .. "/" .. folder
    local stat = vim.loop.fs_stat(path)
    if stat then
      vim.env.VIRTUAL_ENV = path
      break
    end
  end
end

if not dap.adapters.python then
  dappy.setup(vim.env.VIRTUAL_ENV .. "/bin/python")
  dappy.test_runner = "pytest"
  vim.keymap.set("n", "<leader>dPt", dappy.test_method, { desc = "Debug Method", silent = true })
  vim.keymap.set("n", "<leader>dPc", dappy.test_class, { desc = "Debug Method", silent = true })
end

vim.api.nvim_create_user_command("RuffCheck", function()
  local output = vim.fn.system("poetry run ruff check --output-format concise -q")
  if vim.v.shell_error ~= 0 then
    local lines = vim.fn.split(output, "\n")
    local qflist = {}
    for _, line in ipairs(lines) do
      local filename, lnum, col, text = string.match(line, "([^:]+):(%d+):(%d+):%s*(.*)")
      if filename and lnum and col and text then
        table.insert(qflist, {
          filename = filename,
          lnum = tonumber(lnum),
          col = tonumber(col),
          text = text,
        })
      end
    end
    vim.fn.setqflist(qflist)
    vim.cmd("copen")
  else
    print("All checks passed!")
  end
end, {})
