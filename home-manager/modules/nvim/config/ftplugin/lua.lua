local dap = require("dap")

dap.adapters.nlua = function(callback, conf)
  local port = conf["port"]
  local adapter = {
    type = "server",
    host = "127.0.0.1",
    port = port,
  }
  if conf.start_neovim then
    local original_dap_run = dap.run
    ---@diagnostic disable-next-line: duplicate-set-field
    dap.run = function(c)
      adapter.host = c.host
      adapter.port = c.port
    end
    require("osv").run_this()
    dap.run = original_dap_run
  end
  callback(adapter)
end

local function free_port()
  local tcp = vim.loop.new_tcp()
  assert(tcp)
  tcp:bind("127.0.0.1", 0)
  local port = tcp:getsockname().port
  tcp:shutdown()
  tcp:close()
  return port
end

dap.configurations.lua = {
  {
    type = "nlua",
    request = "attach",
    name = "nvim:file",
    port = free_port(),
    start_neovim = {},
  },
  {
    type = "nlua",
    request = "attach",
    name = "nvim:prompt-cwd",
    port = free_port,
    start_neovim = {
      prompt = true,
    },
  },
  {
    type = "nlua",
    request = "attach",
    name = "Attach to running Neovim instance",
    port = function()
      local port = tonumber(vim.fn.input("Port: "))
      return port or dap.ABORT
    end,
  },
}
