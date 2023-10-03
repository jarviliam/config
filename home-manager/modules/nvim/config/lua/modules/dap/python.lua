local ok, dap = as.safe_require("dap")
local map = vim.keymap.set
if not ok then
  return
end
local dap_python = require("dap-python")
dap_python.setup("~/.virtualenvs/debugpy/bin/python")
dap_python.test_runner = "pytest"

map("n", "<Space>dpm", dap_python.test_method, { desc = "dap: Test python method" })
map("n", "<Space>dpc", dap_python.test_class, { desc = "dap: Test python class" })

table.insert(dap.configurations.python, {
  name = "Api",
  type = "python",
  request = "attach",
  host = "localhost",
  port = 10001,
  justMyCode = false,
  pathMappings = {
    {
      localRoot = vim.fn.getcwd() .. "/.venv/",
      remoteRoot = "/opt/pysetup/.venv/",
    },
  },
})

table.insert(dap.configurations.python, {
  name = "(Docker)KumamushiAPI",
  type = "python",
  request = "attach",
  host = "localhost",
  port = 10001,
  justMyCode = false,
  pathMappings = {
    {
      localRoot = vim.fn.getcwd() .. "/.venv/",
      remoteRoot = "/opt/pysetup/.venv/",
    },
    {
      localRoot = vim.fn.getcwd(),
      remoteRoot = "/km-api/",
    },
  },
})
