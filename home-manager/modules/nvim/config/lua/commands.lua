vim.api.nvim_create_user_command("Todos", function()
  require("fzf-lua").grep({ search = [[TODO:|todo!\(.*\)]], no_esc = true })
end, { desc = "Grep TODOs", nargs = 0 })

vim.api.nvim_create_user_command("ClearLspLog", function()
  local lsp_log_path = vim.fn.stdpath("state") .. "/lsp.log"
  if vim.fn.filereadable(lsp_log_path) == 0 then
    vim.notify("No cache found")
    return
  end
  os.remove(vim.fn.stdpath("state") .. "/lsp.log")
  vim.notify("Cache cleared")
end, { desc = "Deletes the lsp log", nargs = 0 })

vim.api.nvim_create_user_command("NotifySplit", function()
  local notify = require("notify")

  local lines = {}
  for _, notif in ipairs(notify.history()) do
    table.insert(lines, ("%s %s: %s"):format(notif.title[1], notif.title[2], table.concat(notif.message, "\n")))
  end
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.cmd("vsplit")
  vim.api.nvim_win_set_buf(0, buf)
end, { desc = "Show Notifications History in a split" })

