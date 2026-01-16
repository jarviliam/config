Config.now(function()
  vim.pack.add({ "https://github.com/folke/snacks.nvim" }, { load = true })

  require("snacks").setup({
    bigfile = { enabled = true, notify = true },
    terminal = {
      enabled = true,
      shell = "zsh",
    },
    quickfile = { enabled = true },
    input = { enabled = true },
    scope = {
      enabled = true,
    },
    statuscolumn = {
      enabled = false,
      left = { "git" },
      right = { "sign" },
      git = { patterns = { "GitSign" } },
    },
    words = { enabled = false },
  })
  _G.dd = function(...)
    Snacks.debug.inspect(...)
  end
  _G.bt = function()
    Snacks.debug.backtrace()
  end
  vim.print = _G.dd
end)
