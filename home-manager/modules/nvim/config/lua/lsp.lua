local fzf = require("fzf-lua")
local diagnostic_icons = require("icons").diagnostics
local methods = vim.lsp.protocol.Methods

local M = {}

--- Sets up the Keymaps and autocommands
---@param client vim.lsp.Client
---@param bufnr integer
local function on_attach(client, bufnr)
  ---@param lhs string
  ---@param rhs string|function
  ---@param opts string|table
  ---@param mode? string|string[]
  local function keymap(lhs, rhs, opts, mode)
    opts = type(opts) == "string" and { desc = opts }
      or vim.tbl_extend("error", opts --[[@as table]], { buffer = bufnr })
    vim.keymap.set(mode or "n", lhs, rhs, opts)
  end

  --- @param keys string
  local function feedkeys(keys)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), "n", true)
  end

  local function pumvisible()
    return tonumber(vim.fn.pumvisible()) ~= 0
  end

  if client.server_capabilities.signatureHelpProvider then
    client.server_capabilities.signatureHelpProvider.triggerCharacters = {}
  end

  local supports_signatureHelp = client.supports_method(methods.textDocument_signatureHelp)
  local supports_completion = client.supports_method(methods.textDocument_completion)
  local supports_implementation = client.supports_method(methods.textDocument_implementation)
  local supports_codeAction = client.supports_method(methods.textDocument_codeAction)
  local supports_definition = client.supports_method(methods.textDocument_definition)
  local supports_documentHighlight = client.supports_method(methods.textDocument_documentHighlight)
  local supports_inlayHint = client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint)

  if supports_completion then
    local lsp_compl = require("lsp_compl")
    if vim.lsp.completion then
      vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
    else
      lsp_compl.attach(client, bufnr, { server_side_fuzzy_completion = true })
    end

    keymap("<cr>", function()
      return lsp_compl.accept_pum() and "<C-y>" or "<cr>"
    end, { expr = true }, "i")

    keymap("/", function()
      return pumvisible() and "<C-e>" or "/"
    end, { expr = true }, "i")

    keymap("<C-n>", function()
      if pumvisible() then
        feedkeys("<C-n>")
      else
        vim.lsp.completion.trigger()
      end
    end, "Trigger/select next completion", "i")

    keymap("<Tab>", function()
      if pumvisible() then
        feedkeys("<C-n>")
      elseif vim.snippet.active({ direction = 1 }) then
        vim.snippet.jump(1)
      else
        feedkeys("<Tab>")
      end
    end, {}, { "i", "s" })

    keymap("<S-Tab>", function()
      if pumvisible() then
        feedkeys("<C-p>")
      elseif vim.snippet.active({ direction = -1 }) then
        vim.snippet.jump(-1)
      else
        feedkeys("<S-Tab>")
      end
    end, {}, { "i", "s" })

    keymap("<C-u>", "<C-x><C-n>", { desc = "Buffer completions" }, "i")
    -- Inside a snippet, use backspace to remove the placeholder.
    keymap("<BS>", "<C-o>s", {}, "s")
  end

  keymap("grr", function()
    fzf.lsp_references({ jump_to_single_result = true })
  end, "Go to references")

  keymap("gy", "<cmd>FzfLua lsp_typedefs<cr>", "goto type definition [LSP]")

  if supports_implementation then
    local op = function()
      fzf.lsp_implementations({ jump_to_single_result = true })
    end
    keymap("<leader>gi", op, "Go to implementation")
  end

  if supports_codeAction then
    keymap("gra", function()
      fzf.lsp_code_actions({
        winopts = {
          relative = "cursor",
          row = 1.01,
          col = 0,
          height = 0.20,
          width = 0.55,
        },
      })
    end, "lsp: code actions")
  end

  if supports_definition then
    keymap("gd", function()
      fzf.lsp_definitions({ jump_to_single_result = true })
    end, "Go to definition")
    keymap("gD", fzf.lsp_definitions, "Peek definition")
  end

  if supports_signatureHelp then
    keymap("<C-k>", function()
      if pumvisible() then
        feedkeys("<C-e>")
      end
      vim.lsp.buf.signature_help()
    end, "signature help", "i")
  end

  if supports_documentHighlight then
    local hl_group = vim.api.nvim_create_augroup("jarviliam/cursor_highlights", { clear = false })
    vim.api.nvim_create_autocmd({ "CursorHold", "InsertLeave", "BufEnter" }, {
      group = hl_group,
      desc = "Highlight references under cursor",
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter", "BufLeave" }, {
      group = hl_group,
      desc = "Clear highlight references",
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })
  end

  if supports_inlayHint then
    local inlay_hints_group = vim.api.nvim_create_augroup("Toggle_Inlay_Hints", { clear = false })
    vim.defer_fn(function()
      local mode = vim.api.nvim_get_mode().mode
      vim.lsp.inlay_hint.enable(mode == "n" or mode == "v", { bufnr = bufnr })
    end, 500)
    vim.api.nvim_create_autocmd("InsertEnter", {
      group = inlay_hints_group,
      desc = "Enable inlay hints",
      buffer = bufnr,
      callback = function()
        vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
      end,
    })
    vim.api.nvim_create_autocmd("InsertLeave", {
      group = inlay_hints_group,
      desc = "Disable inlay hints",
      buffer = bufnr,
      callback = function()
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
      end,
    })
  end

  vim.keymap.set("n", "<leader>cf", function()
    vim.lsp.buf.format({ async = true })
  end, { silent = true, buffer = bufnr, desc = "Format" })

  local lsp_fmt_group = vim.api.nvim_create_augroup("LspFormattingGroup", {})
  vim.api.nvim_create_autocmd("BufWritePost", {
    group = lsp_fmt_group,
    callback = function(ev)
      local efm = vim.lsp.get_clients({ name = "efm", bufnr = ev.buf })
      if vim.tbl_isempty(efm) then
        return
      end
      vim.lsp.buf.format({ name = "efm" })
    end,
  })

  -- workaround for gopls not supporting semanticTokensProvider
  -- https://github.com/golang/go/issues/54531#issuecomment-1464982242
  if client.name == "gopls" and not client.server_capabilities.semanticTokensProvider then
    local semantic = client.config.capabilities.textDocument.semanticTokens
    client.server_capabilities.semanticTokensProvider = {
      full = true,
      legend = { tokenModifiers = semantic.tokenModifiers, tokenTypes = semantic.tokenTypes },
      range = true,
    }
  end
  if vim.g._workspace_diagnostics_enabled then
    if client.name == "gopls" then
      require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)
    end
  end
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
    on_attach(_client, args.buf)
  end,
})

return M
