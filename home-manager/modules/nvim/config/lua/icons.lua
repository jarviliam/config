local M = {}

M.diagnostics = {
  ERROR = "",
  WARN = "",
  HINT = "",
  INFO = "",
}

M.symbol_kinds = {
  Array = "󰅪",
  Boolean = "⊨",
  Class = "󰌗",
  Constructor = "",
  File = "󰈙",
  Folder = "󰉋",
  Key = "󰌆",
  Namespace = "󰅪",
  Null = "NULL",
  Number = "#",
  Object = "󰀚",
  Package = "󰏗",
  Property = "",
  Reference = "",
  Snippet = "",
  String = "󰀬",
  TypeParameter = "󰊄",
  Unit = "",
}

M.misc = {
  bug = "",
  git = "",
  search = "",
  vertical_bar = "│",
}

M.arrows = {
    right = '',
    left = '',
    up = '',
    down = '',
}

return M
