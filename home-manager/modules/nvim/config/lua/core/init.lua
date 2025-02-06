require("core.global")
require("core.options")
require("keymaps")
require("core.events")
require("winbar")
require("commands")
require("completion")
require("core.lazyplug")

for severity, icon in pairs(_G.ui.icons.diagnostics) do
  local hl = "DiagnosticSign" .. severity:sub(1, 1):upper() .. severity:sub(2):lower()
  vim.fn.sign_define(hl, { text = icon, texthl = hl })
end

vim.diagnostic.config({
  jump = { float = true },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = _G.ui.icons.diagnostics.error,
      [vim.diagnostic.severity.WARN] = _G.ui.icons.diagnostics.warn,
      [vim.diagnostic.severity.HINT] = _G.ui.icons.diagnostics.hint,
      [vim.diagnostic.severity.INFO] = _G.ui.icons.diagnostics.info,
    },
  },
  virtual_lines = false,
  virtual_text = {
    severity = { min = vim.diagnostic.severity.WARN },
    prefix = function(_, _, total)
      return (total > 1 and "• " or "")
    end,
    format = function(diagnostic)
      local icon = _G.ui.icons.diagnostics[vim.diagnostic.severity[diagnostic.severity]:lower()]
      local message = vim.split(diagnostic.message, "\n")[1]
      return string.format("%s %s ", icon, message)
    end,
  },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    focusable = true,
    source = "if_many",
    border = "rounded",
    suffix = function(diag)
      local text = ""
      if package.loaded["rulebook"] then
        text = require("rulebook").hasDocs(diag) and "  " or ""
      end
      return text, ""
    end,
  },
})

Snacks.toggle
  .new({
    name = "DiagnosticLine",
    get = function()
      return vim.diagnostic.config().virtual_lines
    end,
    set = function(state)
      vim.diagnostic.config({ virtual_lines = state })
    end,
  })
  :map("\\l")

-- Override the virtual text diagnostic handler so that the most severe diagnostic is shown first.
local show_handler = vim.diagnostic.handlers.virtual_text.show
assert(show_handler)
local hide_handler = vim.diagnostic.handlers.virtual_text.hide
vim.diagnostic.handlers.virtual_text = {
  show = function(ns, bbufnr, diagnostics, opts)
    table.sort(diagnostics, function(diag1, diag2)
      return diag1.severity > diag2.severity
    end)
    return show_handler(ns, bbufnr, diagnostics, opts)
  end,
  hide = hide_handler,
}

vim.api.nvim_create_autocmd("LspAttach", {
  desc = "Configure LSP Keymaps",
  callback = function(args)
    local _client = vim.lsp.get_client_by_id(args.data.client_id)
    if not _client then
      return
    end
    require("lsp").on_attach(_client, args.buf)
  end,
})

local conf = require("conf")
vim.cmd(string.format("colorscheme %s", conf.theme))
