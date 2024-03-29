local ok, dap = as.safe_require("dap")
if not ok then
  return
end
require("dap-go").setup({
  dap_configurations = {
    {
      type = "go",
      name = "Scanner-Worker",
      mode = "remote",
      substitutePath = {
        {
          from = "${workspaceFolder}",
          to = "/debug/",
        },
        {
          from = "/Users/liam.jarvis/go/pkg/",
          to = "/go/pkg/",
        },
      },
      request = "attach",
      port = 40001,
    },
    {
      type = "go",
      name = "Upload-Worker Attach",
      mode = "remote",
      request = "attach",
      substitutePath = {
        {
          from = "${workspaceFolder}",
          to = "/debug/",
        },
        {
          from = "/Users/liam.jarvis/go/pkg/",
          to = "/go/pkg/",
        },
      },
      port = 40000,
    },
  },
  delve = {
    initialize_timeout_sec = 20,
    port = "${port}",
  },
})

-- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
-- dap.adapters.dockergo = function(callback, config)
--   local stdout = vim.loop.new_pipe(false)
--   local handle
--   local pid_or_err
--   local host = config.host or "127.0.0.1"
--   local port = config.port or 38697
--   local addr = string.format("%s:%s", host, port)
--   local opts = {
--     stdio = { nil, stdout },
--     args = { "connect", addr, "--log" },
--     detached = true,
--   }
--   handle, pid_or_err = vim.loop.spawn("dlv", opts, function(code)
--     stdout:close()
--     handle:close()
--     if code ~= 0 then
--       print("dlv exited with code", code)
--     end
--   end)
--   assert(handle, "Error running dlv: " .. tostring(pid_or_err))
--   stdout:read_start(function(err, chunk)
--     assert(not err, err)
--     if chunk then
--       vim.schedule(function()
--         require("dap.repl").append(chunk)
--       end)
--     end
--   end)
--   -- Wait for delve to start
--   vim.defer_fn(function()
--     callback({ type = "server", host = "127.0.0.1", port = port })
--   end, 100)
-- end

-- dap.adapters.go = function(callback, config)
--   local stdout = vim.loop.new_pipe(false)
--   local handle
--   local pid_or_err
--   local port = 38697
--   local opts = {
--     stdio = { nil, stdout },
--     args = { "dap", "-l", "127.0.0.1:" .. port },
--     detached = true,
--   }
--   handle, pid_or_err = vim.loop.spawn("dlv", opts, function(code)
--     stdout:close()
--     handle:close()
--     if code ~= 0 then
--       print("dlv exited with code", code)
--     end
--   end)
--   assert(handle, "Error running dlv: " .. tostring(pid_or_err))
--   stdout:read_start(function(err, chunk)
--     assert(not err, err)
--     if chunk then
--       vim.schedule(function()
--         require("dap.repl").append(chunk)
--       end)
--     end
--   end)
--   -- Wait for delve to start
--   vim.defer_fn(function()
--     callback({ type = "server", host = "127.0.0.1", port = port })
--   end, 100)
-- end

-- dap.configurations.go = {
--   {
--     type = "go",
--     name = "Debug",
--     request = "launch",
--     program = "${file}",
--   },
--   {
--     type = "go",
--     name = "Debug test", -- configuration for debugging test files
--     request = "launch",
--     mode = "test",
--     program = "${file}",
--   },
--   -- works with go.mod packages and sub packages
--   {
--     type = "go",
--     name = "Debug test (go.mod)",
--     request = "launch",
--     mode = "test",
--     program = "./${relativeFileDirname}",
--   },
-- }
