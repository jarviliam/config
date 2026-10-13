Config.now(function()
  vim.pack.add({ "https://github.com/tpope/vim-fugitive" })

  require("mini.git").setup({ command = { split = "vertical" } })
  vim.api.nvim_set_hl(0, "GitBlameHashRoot", { link = "Tag" })
  vim.api.nvim_set_hl(0, "GitBlameHash", { link = "Identifier" })
  vim.api.nvim_set_hl(0, "GitBlameAuthor", { link = "String" })
  vim.api.nvim_set_hl(0, "GitBlameDate", { link = "Comment" })

  Config.new_autocmd("User", {
    pattern = "MiniGitCommandSplit",
    callback = function(e)
      if e.data.git_subcommand ~= "blame" then
        return
      end
      local win_src = e.data.win_source
      local buf = e.buf
      local win = e.data.win_stdout
      -- Opts
      vim.bo[buf].modifiable = false
      vim.wo[win].wrap = false
      vim.wo[win].cursorline = true
      vim.wo[win].cursorlineopt = "both"
      -- View
      vim.fn.winrestview({ topline = vim.fn.line("w0", win_src) })
      vim.api.nvim_win_set_cursor(0, { vim.fn.line(".", win_src), 0 })
      vim.wo[win].scrollbind, vim.wo[win_src].scrollbind = true, true
      vim.wo[win].cursorbind, vim.wo[win_src].cursorbind = true, true

      -- Highlight
      vim.fn.matchadd("GitBlameHash", [[^[^^]\S\+]])
      vim.fn.matchadd("GitBlameHashRoot", [[^^\S\+]])
      vim.fn.matchadd("GitBlameAuthor", [[\v\(\zs.*\ze\s\d{4}-]])
      vim.fn.matchadd("GitBlameDate", [[\v\d{4}-.*\ze\s\d+\)]])
      vim.api.nvim_win_set_hl_ns(win, 0)

      -- Vert width
      if e.data.cmd_input.mods:match("vertical") then
        local lines = vim.api.nvim_buf_get_lines(0, 1, -1, false)
        local width = vim.iter(lines):fold(-1, function(acc, ln)
          local stat = string.match(ln, "^%S+ %b()")
          return math.max(acc, vim.fn.strwidth(stat))
        end)
        width = width + vim.fn.getwininfo(win)[1].textoff
        vim.api.nvim_win_set_width(win, width)
      end
    end,
    desc = "Better Blame",
  })

  Config.new_cmd("Blame", function()
    vim.cmd("lefta vertical Git blame -- %:p")
  end, { desc = "Show git blame info for the current file" })

  local git_log_cmd = [[Git log --pretty=format:\%h\ \%as\ │\ \%s\%d\ [\%an] --graph --all]]
  Config.minigit_log = function()
    vim.cmd(git_log_cmd)
  end
  Config.minigit_log_buf = function()
    vim.cmd(git_log_cmd .. " --follow -- %")
  end
end)
