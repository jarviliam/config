local M = {}

function M.get_snippets()
    local snippets = require("nvim-snippets")
    _G.dump(snippets.get_loaded_snippets())
end

function M.fzf_snippets()
  local fzflua = require("fzf-lua")

  local snippets = {}

  local opts = {}
  if not opts.query then
    local match = "[^%s\"']*"
    local line = vim.api.nvim_get_current_line()
    local col = vim.api.nvim_win_get_cursor(0)[2] + 1
    local before = col > 1 and line:sub(1, col - 1):reverse():match(match):reverse() or ""
    opts.query = before
  end

  opts.action = {
    ["default"] = function(selected, _opts)
      local select = selected[1]

      local index = select:match("^%d+")
      local sp = snippets[tonumber(index)]
      if not sp then
        vim.notify("No snippets selected")
        return
      end

      if not sp.body then
        return
      end

      local body = type(sp.body) == "string" and sp.body or table.concat(sp.body, "\n")
      vim.defer_fn(function()
        vim.cmd.startinsert()
        vim.snippet.expand(body)
      end, 1)
    end,
  }

  local contents = vim
    .iter(ipairs(snippets))
    :map(function(i, snip)
      return string.format("%s: %s", i, snip.description or snip.name)
    end)
    :totable()

  return fzflua.fzf_exec(contents, opts)
end

return M
