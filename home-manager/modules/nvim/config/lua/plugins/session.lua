return {
  ---@module "stevearc/resession.nvim"
  "stevearc/resession.nvim",
  priority = 100,
  init = function()
    vim.api.nvim_create_user_command("SessionLoad", function()
      require("resession").load(Snacks.git.get_root(), { silence_errors = false })
    end, { desc = "Load session" })
    vim.api.nvim_create_autocmd("VimLeavePre", {
      callback = function()
        require("resession").save(Snacks.git.get_root(), { notify = false })
      end,
    })
  end,
  opts = {
    buf_filter = function(bufnr)
      local buftype = vim.bo[bufnr].buftype
      local ignored_bufs = { "trouble" }
      if buftype ~= "" and buftype ~= "acwrite" then
        return false
      end
      if vim.tbl_contains(ignored_bufs, buftype) then
        return false
      end
      return vim.bo[bufnr].buflisted
    end,
  },
  config = function(opts)
    require("resession").setup(opts)
  end,
}
