local M = {}
function M.bootstrap()
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

  if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable",
      lazypath,
    })
  end

  vim.opt.rtp:prepend(lazypath)
end

function M.setup()
  M.bootstrap()
  require("lazy").setup({
    defaults = { lazy = true },
    dev = { path = vim.env.HOME .. "/Coding" },
    lockfile = vim.env.HOME .. "/.lazy-lock.json",
    install = { colorscheme = { "nightfly", "lua-embark" } },
    checker = { enabled = false },
    spec = {
      { import = "plugins" },
      { import = "plugins.ai" },
    },
    ui = {
      border = "rounded",
      custom_keys = {
        ["<localleader>l"] = false,
        ["<localleader>t"] = false,
      },
    },
    performance = {
      rtp = {
        disabled_plugins = {
          "netrw",
          "netrwPlugin",
          "netrwSettings",
          "netrwFileHandlers",
          "gzip",
          "zip",
          "zipPlugin",
          "tar",
          "tarPlugin",
          "getscript",
          "getscriptPlugin",
          "vimball",
          "vimballPlugin",
          "2html_plugin",
          "logipat",
          "rrhelper",
          "spellfile_plugin",
          "matchit",
        },
        paths = {
          vim.fs.joinpath(tostring(vim.fn.stdpath("data")), "ts-install"),
        },
      },
    },
    debug = false,
  })
end

return M
