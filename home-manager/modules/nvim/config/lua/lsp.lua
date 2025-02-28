local methods = vim.lsp.protocol.Methods
local M = {}

---@param filter 'Function' | 'Module' | 'Struct'
local function filtered_document_symbol(filter)
  vim.lsp.buf.document_symbol()
  vim.cmd.Cfilter(("[[%s]]"):format(filter))
end
local function symbol_methods()
  filtered_document_symbol("Function")
end

local function symbol_modules()
  filtered_document_symbol("Module")
end

local function symbol_structs()
  filtered_document_symbol("Struct")
end

--- Sets up the Keymaps and autocommands
---@param client vim.lsp.Client
---@param bufnr integer
function M.on_attach(client, bufnr)
  local fzf = require("fzf-lua")

  ---@param lhs string
  ---@param rhs string|function
  ---@param opts string|table
  ---@param mode? string|string[]
  local function keymap(lhs, rhs, opts, mode)
    opts = type(opts) == "string" and { desc = opts }
      or vim.tbl_extend("error", opts --[[@as table]], { buffer = bufnr })
    vim.keymap.set(mode or "n", lhs, rhs, opts)
  end

  keymap("[d", function()
    vim.diagnostic.jump({ count = -1 })
  end, "Previous diagnostic")
  keymap("]d", function()
    vim.diagnostic.jump({ count = 1 })
  end, "Next diagnostic")
  keymap("[e", function()
    vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR })
  end, "Previous error")
  keymap("]e", function()
    vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR })
  end, "Next error")

  keymap("grr", function()
    fzf.lsp_references({ jump1 = true })
  end, "Go to references")

  keymap("gy", "<cmd>FzfLua lsp_typedefs<cr>", "goto type definition [LSP]")

  if client:supports_method(methods.textDocument_implementation) then
    local op = function()
      fzf.lsp_implementations({ jump1 = true })
    end
    keymap("<leader>gi", op, "Go to implementation")
  end

  if client:supports_method(methods.textDocument_codeAction) then
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

  if client:supports_method(methods.textDocument_definition) then
    keymap("gd", function()
      fzf.lsp_definitions({ jump1 = true })
    end, "Go to definition")
    keymap("gD", function()
      fzf.lsp_definitions({ jump1 = false })
    end, "Peek definition")
  end

  if client:supports_method(methods.textDocument_signatureHelp) then
    local blink_window = require("blink.cmp.completion.windows.menu")
    local blink = require("blink.cmp")

    keymap("<C-k>", function()
      -- Close the completion menu first (if open).
      if blink_window.win:is_open() then
        blink.hide()
      end

      vim.lsp.buf.signature_help()
    end, "Signature help", "i")
  end

  keymap("<leader>grn", vim.lsp.buf.rename, "Rename symbol")

  if client:supports_method(methods.textDocument_documentHighlight) then
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

  if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
    vim.keymap.set("n", "<leader>ci", function()
      local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
      vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
      if not enabled then
        vim.api.nvim_create_autocmd("InsertEnter", {
          once = true,
          buffer = bufnr,
          callback = function()
            vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
          end,
        })
      end
    end, { desc = "Toggle Inlay Hints" })
  end

  -- workaround for gopls not supporting semanticTokensProvider
  -- https://github.com/golang/go/issues/54531#issuecomment-1464982242
  if client.name == "gopls" and not client.server_capabilities.semanticTokensProvider then
    local semantic = client.config.capabilities.textDocument.semanticTokens
    if semantic then
      client.server_capabilities.semanticTokensProvider = {
        full = true,
        legend = { tokenModifiers = semantic.tokenModifiers, tokenTypes = semantic.tokenTypes },
        range = true,
      }
    end
  end

  keymap("<space>sf", symbol_methods, { desc = "symbols: [f]unction" })
  keymap("<space>sss", symbol_structs, { desc = "symbols: [s]tructs" })
  keymap("<space>ssi", symbol_modules, { desc = "symbols: [i]mports" })
end

--- Configure the lsp server via lspconfig
---@param server string
---@param settings? table
function M.configure_server(server, settings)
  settings = settings or {}
  settings.capabilities = require("blink.cmp").get_lsp_capabilities(settings.capabilities)
  require("lspconfig")[server].setup(settings)
end

return M
