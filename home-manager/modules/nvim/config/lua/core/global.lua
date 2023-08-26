--- Store Globals
_G.__as_global_callbacks = __as_global_callbacks or {}

_G.as = {
  _store = __as_global_callbacks,
}

as.style = {
  lsp = {
    signs = {
      Error = " ",
      Warn = " ",
      Hint = " ",
      Info = " ",
    },
    kind = {
      Text = " [Text]",
      Method = " [Method]",
      Function = " [Func]",
      Constructor = " [Constructor]",
      Field = "ﰠ [Field]",
      Variable = " [Var]",
      Class = " [Class]",
      Interface = " [Interface]",
      Module = " [Mod]",
      Property = "ﰠ [Prop]",
      Unit = "塞 [Unit]",
      Value = " [value]",
      Enum = " [Enum]",
      Keyword = " [Key]",
      Snippet = " [Snip]",
      Color = " [color]",
      File = " [File]",
      Reference = " [Ref]",
      Folder = " [Folder]",
      EnumMember = " [Enum Member]",
      Constant = " [Const]",
      Struct = "פּ [Struct]",
      Event = " [Event]",
      Operator = " [Op]",
      TypeParameter = "",
    },
    border = {
      { "┌", "FloatBorder" },
      { "─", "FloatBorder" },
      { "┐", "FloatBorder" },
      { "│", "FloatBorder" },
      { "┘", "FloatBorder" },
      { "─", "FloatBorder" },
      { "└", "FloatBorder" },
      { "│", "FloatBorder" },
    },
  },
}

---Prints out inspect
---@param ... any
---@return any
function P(...)
  local objects, v = {}, nil
  for i = 1, select("#", ...) do
    v = select(i, ...)
    table.insert(objects, vim.inspect(v))
  end
  print(table.concat(objects, "\n"))
  return ...
end

---Dumps text
---@param ... any
---@return any
function _G.dump_text(...)
  local objects, v = {}, nil
  for i = 1, select("#", ...) do
    v = select(i, ...)
    table.insert(objects, vim.inspect(v))
  end

  local lines = vim.split(table.concat(objects, "\n"), "\n")
  local lnum = vim.api.nvim_win_get_cursor(0)[1]
  vim.fn.append(lnum, lines)
  return ...
end

---Checks if a cmd is an executable
---@param e string
---@return boolean
function as.executable(e)
  return vim.fn.executable(e) > 0
end

---@class Autocommand
---@field events string[] list of autocommand events
---@field targets string[] list of autocommand patterns
---@field modifiers string[] e.g. nested, once
---@field command string | function

---Checks to see if command is valid
---@param command Autocommand
---@return boolean
local function is_valid_target(command)
  local valid_type = command.targets and vim.tbl_islist(command.targets)
  return valid_type or vim.startswith(command.events[1], "User ")
end

function as._create(f)
  table.insert(as._store, f)
  return #as._store
end

function as._execute(id, args)
  as._store[id](args)
end

---Creates an autocmd
---@param name string
---@param commands Autocommand[]
function as.augroup(name, commands)
  vim.cmd("augroup " .. name)
  vim.cmd("autocmd!")
  for _, c in ipairs(commands) do
    if c.command and c.events and is_valid_target(c) then
      local command = c.command
      if type(command) == "function" then
        local fn_id = as._create(command)
        command = string.format("lua as._execute(%s)", fn_id)
      end
      c.events = type(c.events) == "string" and { c.events } or c.events
      vim.cmd(
        string.format(
          "autocmd %s %s %s %s",
          table.concat(c.events, ","),
          table.concat(c.targets or {}, ","),
          table.concat(c.modifiers or {}, " "),
          command
        )
      )
    else
      vim.notify(string.format("Autocmd in %s is typed wrong: %s", name, vim.inspect(name)), vim.log.levels.ERROR)
    end
  end
  vim.cmd("augroup END")
end

---Requires modules via pcall and outputs errors
---@param module string
---@param opts table { silent }
---@return boolean, any
function as.safe_require(module, opts)
  opts = opts or { silent = false }
  local ok, result = pcall(require, module)
  if not ok and not opts.silent then
    vim.notify(result, vim.log.levels.ERROR, { title = string.format("Error requiring: %s", module) })
  end
  return ok, result
end
