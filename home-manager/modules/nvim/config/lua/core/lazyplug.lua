local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
local ok, lazy = pcall(require, "lazy")
if not ok then
  return
end

lazy.setup("plugins", {
  defaults = { lazy = true },
  dev = { path = vim.g.personal_dir },
  lockfile = vim.env.HOME .. "/nix_dot/home-manager/modules/nvim/lazy-lock.json",
  install = { colorscheme = { "nightfly", "lua-embark" } },
  checker = { enabled = false },
  ui = {
    border = "rounded",
    custom_keys = {
      ["<localleader>l"] = false,
      ["<localleader>t"] = false,
    },
  },
  debug = false,
})
