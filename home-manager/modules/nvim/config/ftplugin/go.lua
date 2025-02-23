local dap = require("dap")
local dapgo = require("dap-go")

local function get_arguments()
  return coroutine.create(function(dap_run_co)
    local args = {}
    vim.ui.input({ prompt = "Args: " }, function(input)
      args = vim.split(input or "", " ")
      coroutine.resume(dap_run_co, args)
    end)
  end)
end

local function is_git_root()
  local path = vim.uv.cwd()
  local root = Snacks.git.get_root()
  if vim.g._debug_root then
    vim.print(path, root)
  end
  return path == root
end

if not dap.adapters.go then
  dapgo.setup({
    dap_configurations = {
      {
        type = "go",
        name = "Debug Package (Args)",
        request = "launch",
        program = "${fileDirname}",
        args = get_arguments,
      },
      {
        type = "go",
        name = "Debug octopus server folder",
        request = "launch",
        program = function()
          if is_git_root() then
            return "${workspaceFolder}/service/octopus-api/cmd/octopus-api"
          end
          return "${workspaceFolder}/cmd/octopus-api"
        end,
        cwd = "${workspaceFolder}",
        args = { "server" },
      },
      {
        type = "go",
        name = "Debug octopus worker folder",
        request = "launch",
        program = function()
          if is_git_root() then
            return "${workspaceFolder}/service/octopus-api/cmd/octopus-api"
          end
          return "${workspaceFolder}/cmd/octopus-api"
        end,
        cwd = "${workspaceFolder}",
        args = { "worker" },
      },
      {
        type = "go",
        name = "Debug run",
        request = "launch",
        program = function()
          if is_git_root() then
            return "${workspaceFolder}/service/octopus-api/internal/test/debugrun"
          end
          return "${workspaceFolder}/internal/test/debugrun"
        end,
        cwd = "${workspaceFolder}",
      },
    },
  })
end

if not vim.g._loaded_goplements then
  require("goplements").setup()
  vim.g._loaded_goplements = 1
end
