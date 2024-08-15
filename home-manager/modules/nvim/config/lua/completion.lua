local Job = require("plenary.job")
local M = {}

--- @class RemoteInfo
--- @field host string The host of the remote repository.
--- @field owner string The owner of the remote repository.
--- @field repo string The name of the remote repository.

--- Retrieves the remote repository information.
--- @return RemoteInfo|nil
M.get_remote = function()
  local static_remotes = { "upstream", "origin" }
  local host, owner, repo = nil, nil, nil

  for _, remote in ipairs(static_remotes) do
    local cmd = "git config --get remote." .. remote .. ".url"
    local remote_url = vim.fn.system(cmd):gsub("%.git", ""):gsub("%s", "")

    if remote_url ~= "" then
      local patterns = {
        "^git@(.+):(.+)/(.+)$",
        "^https?://(.+)/(.+)/(.+)$",
        "^ssh://git@([^:]+):*.*/(.+)/(.+)$",
      }

      for _, pattern in ipairs(patterns) do
        host, owner, repo = string.match(remote_url, pattern)
        if host and owner and repo then
          break
        end
      end

      if host and owner and repo then
        break
      end
    end
  end
  if not host or not owner or not repo then
    return nil
  end
  return { host = host, owner = owner, repo = repo }
end

---@param results string
---@return table
local function handleResults(results)
  local items = {}
  vim.notify(results)
  return items
end

---@param remote RemoteInfo
M.get_issues = function(remote, callback)
  local cmd = ""
  local args = {}
  local job = Job:new({
    command = cmd,
    args = args,
    cwd = vim.fn.getcwd(),
    on_exit = vim.schedule_wrap(function(job, code)
      if code ~= 0 then
        vim.notify(cmd .. " returned with exit code " .. code)
      else
        vim.notify(cmd .. " returned with a result")
        local result = table.concat(job:result(), "")
        local items = handleResults(result)
        callback({ items = items })
      end
    end),
  })
end

M.gh_complete = function()
  local lnum, col = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_get_current_line()
  local word = vim.fn.matchstr(line, "\\w\\+\\%.c")
  local remote = M.get_remote()
  if ~remote then
    vim.notify("No Remotes found")
  end
  local callback = function(items)
    local matches = {}
    for _, issue in ipairs(items) do
    end
    local line_to_cursor = line:sub(1, col)
    local word_boundary = vim.fn.match(line_to_cursor, "\\k*$")
    vim.fn.complete(word_boundary + 1, matches)
  end
  -- M.get_issues(remote, callback)
end

return M
