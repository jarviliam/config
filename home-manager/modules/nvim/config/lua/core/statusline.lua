local M = {}

M.aerial = function()
  local ah = require("aerial.highlight")

  local parts = {}
  for _, symbol in ipairs({ unpack(require("aerial").get_location()), 1, 5 }) do
    local hl_group = ah.get_highlight(symbol, false, false)
    local name = hl_group and M.as_string(hl_group, symbol.name) or symbol.name

    local icon_hl = ah.get_highlight(symbol, true, false)
    local icon = icon_hl and M.as_string(icon_hl, symbol.icon) or symbol.icon
    table.insert(parts, string.format("%s%s", icon, name))
  end

  if #parts == 0 then
    return ""
  end

  return table.concat(parts, " ⟩ ")
end

function M.as_string(hl, str)
  return "%#" .. hl .. "#" .. str .. "%*"
end

return M
