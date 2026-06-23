---@class PickerConfig
---@field commands? fun(opts?: table): nil
---@field command_history? fun(opts?: table): nil
---@field live_grep? fun(opts?: table): nil
---@field files? fun(opts?: table): nil
---@field files_root? fun(opts?: table): nil
---@field resume? fun(opts?: table): nil
---@field buffers? fun(opts?: table): nil
---@field buffer_lines? fun(opts?: table): nil
---@field git? { files?: fun(opts?: table): nil, buffer_commits?: fun(opts?: table): nil }
---@field grep? { cword?: fun(opts?: table): nil, cWORD?: fun(opts?: table): nil, lines?: fun(opts?: table): nil }
---@field registers? fun(opts?: table): nil
---@field search_history? fun(opts?: table): nil
---@field autocmds? fun(opts?: table): nil
---@field diagnostics? { document?: fun(opts?: table): nil, workspace?: fun(opts?: table): nil }
---@field help? { tags?: fun(opts?: table): nil, man?: fun(opts?: table): nil }
---@field highlights? fun(opts?: table): nil
---@field builtin? fun(opts?: table): nil
---@field keymaps? fun(opts?: table): nil
---@field quickfix? fun(opts?: table): nil
---@field visit_paths? { cwd?: fun(opts?: table): nil, all?: fun(opts?: table): nil }

---@type PickerConfig
Config.picker = {
  commands = nil,
  command_history = nil,
  live_grep = nil,
  files = nil,
  files_root = nil,
  resume = nil,
  buffers = nil,
  buffer_lines = nil,

  git = {
    files = nil,
    buffer_commits = nil,
  },

  grep = {
    cword = nil,
    cWORD = nil,
    lines = nil,
  },
  registers = nil,
  search_history = nil,

  autocmds = nil,

  diagnostics = {
    document = nil,
    workspace = nil,
  },

  help = {
    tags = nil,
    man = nil,
  },

  highlights = nil,
  builtin = nil,

  keymaps = nil,
  quickfix = nil,

  visit_paths = {
    cwd = nil,
    all = nil,
  },
}
