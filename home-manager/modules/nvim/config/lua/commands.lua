vim.api.nvim_create_user_command("Todos", function()
    require("fzf-lua").grep({ search = [[TODO:|todo!\(.*\)]], no_esc = true })
end, { desc = "Grep TODOs", nargs = 0 })
