Config.later(function()
  require("mini.bufremove").setup({})

  Config.minibuf_rm_others = function()
    local bufnr = vim.api.nvim_get_current_buf()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if buf ~= bufnr and vim.api.nvim_buf_is_loaded(buf) then
        MiniBufremove.delete(buf)
      end
    end
  end
end)
