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
  Color = "󰏘",
  Constant = "󰏿",
  Enum = "",
  EnumMember = "",
  Event = "",
  Field = "󰜢",
  Function = "󰆧",
  Interface = "",
  Keyword = "󰌋",
  Method = "󰆧",
  Module = "",
  Operator = "󰆕",
  Struct = "",
  Text = "",
  Value = "",
  Variable = "󰀫",
}

M.misc = {
  bug = "",
  git = "",
  ellipsis = "…",
  search = "",
  vertical_bar = "│",
}

M.arrows = {
  right = "",
  left = "",
  up = "",
  down = "",
}

return M
