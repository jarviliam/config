require("core.global")
require("core.options")
require("keymaps")
require("core.events")
require("winbar")
require("commands")
require("completion")
require("core.lazyplug")

local diagnostic_icons = require("icons").diagnostics

for severity, icon in pairs(diagnostic_icons) do
  local hl = "DiagnosticSign" .. severity:sub(1, 1) .. severity:sub(2):lower()
  vim.fn.sign_define(hl, { text = icon, texthl = hl })
end

vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = diagnostic_icons.ERROR,
      [vim.diagnostic.severity.WARN] = diagnostic_icons.WARN,
      [vim.diagnostic.severity.HINT] = diagnostic_icons.HINT,
      [vim.diagnostic.severity.INFO] = diagnostic_icons.INFO,
    },
  },
  virtual_text = {
    prefix = "",
    format = function(diagnostic)
      local icon = diagnostic_icons[vim.diagnostic.severity[diagnostic.severity]]
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
  },
})

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
