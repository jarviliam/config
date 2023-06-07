----------------------------------------------------
--        _                  _ ___
--       (_)___ _______   __(_) (_)___ _____ ___
--      / / __ `/ ___/ | / / / / / __ `/ __ `__ \  Nvim 0.9 Config
--     / / /_/ / /   | |/ / / / / /_/ / / / / / /
--  __/ /\__,_/_/    |___/_/_/_/\__,_/_/ /_/ /_/
-- /___/
--
----------------------------------------------------

vim.loader.enable()

local ok, reload = pcall(require, "plenary.reload")
local RELOAD = ok and reload.reload_module or function(...)
  return ...
end

local function R(name)
  RELOAD(name)
  return require(name)
end

vim.g.do_filetype_lua = 1
vim.g.loaded_python_provider = 0
vim.g.python3_host_prog = "/Users/liam.jarvis/.pyenv/versions/3.10.1/bin/python"
--
-- Disable built-in plug-ins
local disabled_built_ins = {
  "gzip",
  -- "man",
  "matchit",
  "matchparen",
  "shada_plugin",
  "tarPlugin",
  "tar",
  "zipPlugin",
  "zip",
  "netrwPlugin",
}
for _, plugin in ipairs(disabled_built_ins) do
  vim.g["loaded_" .. plugin] = 1
end

R("conf")
R("core.global")
R("core.auto")
R("core.settings")
R("plugins")
R("core.mappings")
