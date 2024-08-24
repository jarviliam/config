local M = {}
local ns = vim.api.nvim_create_namespace("gh")

function M.comments()
  local branch = vim.trim(vim.fn.system("git branch --show current"))
  local pr_out = vim.fn.system('gh pr list --head "' .. branch .. '" --json number')
  local prs = assert(vim.json.decode(pr_out), "gh pr list did not output")
  if #prs == 0 then
    vim.notify("No PRs found")
  end
  local comments_cmd = 'gh api "repos/{owner}/{repo}/pulls/' .. prs[1].number .. '/comments"'
  local comments = vim.json.decode(vim.fn.system(comments_cmd), { luanil = { object = true } })
  assert(comments)
  local buf_diag = vim.defaulttable()
  for _, c in pairs(comments) do
    if c.line then
      local path = c.path
      local bufnr = vim.fn.bufadd(path)
      table.insert(
        buf_diag[bufnr],
        { bufnr = bufnr, lnum = c.line - 1, col = 0, message = c.body, severity = vim.diagnostic.severity.WARN }
      )
    end
  end
  local qflist = {}
  for bufnr, diagnostic in pairs(buf_diag) do
    local list = vim.diagnostic.toqflist(diagnostic)
    vim.list_extend(qflist, list)
    vim.diagnostic.set(ns, bufnr, diagnostic)
  end
  vim.fn.setqflist(qflist, "r")
  vim.cmd.copen()
end

function M.clear()
  vim.diagnostic.reset(ns)
end

return M
