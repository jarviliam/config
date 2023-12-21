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
return M
