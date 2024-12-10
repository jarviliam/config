vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("my_winbar", { clear = true }),
  desc = "Attach Winbar",
  callback = function(args)
    if
      not vim.api.nvim_win_get_config(0).zindex -- Not a floating window
      and vim.bo[args.buf].buftype == "" -- Normal buffer
      and vim.api.nvim_buf_get_name(args.buf) ~= "" -- Has a file name
      and not vim.wo[0].diff -- Not in diff mode
    then
      vim.wo.winbar = "%= %#WinBarDir# %t "
    end
  end,
})
