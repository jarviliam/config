local ok, dap = as.safe_require("dap")
if not ok then
  return
end
require("dap-python").setup("~/.virtualenvs/debugpy/bin/python")

table.insert(dap.configurations.python, {
  name = "KumamushiAPI",
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
