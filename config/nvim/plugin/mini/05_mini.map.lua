local map = require("mini.map")
Config.now_if_args(function()
  map.setup({
    integrations = {
      map.gen_integration.builtin_search(),
      map.gen_integration.diagnostic(),
      map.gen_integration.diff(),
    },
    symbols = {
      encode = map.gen_encode_symbols.dot("4x2"),
    },
    window = {
      zindex = 21,
    },
  })
end)

local auto_enable = {
  go = true,
  lua = true,
  markdown = true,
  python = true,
  rust = true,
}

local function shouldEnable()
  local ft = vim.bo.filetype
  local disabled = vim.b.minimap_disable
  local enabled_explicitly = vim.b.minimap_disable == false
  return enabled_explicitly or auto_enable[ft] and not disabled
end

Config.new_autocmd("BufEnter", {
  desc = "Toggle mini.map",
  callback = vim.schedule_wrap(function()
    if vim.bo.filetype == "minimap" then
      return
    end
    if shouldEnable() then
      map.open()
    else
      map.close()
    end
  end),
})
