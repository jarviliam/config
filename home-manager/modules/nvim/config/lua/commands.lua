vim.api.nvim_create_user_command("Todos", function()
  require("fzf-lua").grep({ search = [[TODO:|todo!\(.*\)]], no_esc = true })
end, { desc = "Grep TODOs", nargs = 0 })

vim.api.nvim_create_user_command("Jq", function()
  local buf_lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local input = table.concat(buf_lines, "\n")
  local output = vim.fn.systemlist("jq .", input)
  if vim.v.shell_error ~= 0 then
    vim.print(output)
    return
  end
  vim.api.nvim_buf_set_lines(0, 0, -1, false, output)
end, { desc = "Run JQ", nargs = 0 })
