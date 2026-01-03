local M = {}

function M.is_darwin()
  return vim.loop.os_uname().sysname == "Darwin"
end

function M.get_trunk_branch()
  if not vim.g._trunk_branch then
    local result = vim.fn.system("git remote show origin | grep 'HEAD branch' | awk '{print $NF}'")
    vim.g._trunk_branch = result:gsub("%s+", "")
  end
  return vim.g._trunk_branch
end

return M
