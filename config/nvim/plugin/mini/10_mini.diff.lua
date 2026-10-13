Config.later(function()
  require("mini.diff").setup({})

  Config.minidiff_to_qf = function()
    vim.fn.setqflist(MiniDiff.export("qf"))
    vim.cmd("copen")
  end
end)
