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
  local methods = vim.lsp.protocol.Methods

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

  if vim.g._native_compl and client.server_capabilities.signatureHelpProvider then
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
    if vim.g._native_compl then
      vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
      keymap("<cr>", function()
        return pumvisible() and "<C-y>" or "<cr>"
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
    end

    keymap("<C-u>", "<C-x><C-n>", { desc = "Buffer completions" }, "i")

    -- Inside a snippet, use backspace to remove the placeholder.
    keymap("<BS>", "<C-o>s", {}, "s")

    if vim.g._native_compl then
      vim.api.nvim_create_autocmd("CompleteChanged", {
        buffer = bufnr,
        callback = function()
          local info = vim.fn.complete_info({ "selected" })
          local completionItem = vim.tbl_get(vim.v.completed_item, "user_data", "nvim", "lsp", "completion_item")
          if nil == completionItem then
            return
          end

          local resolvedItem =
            vim.lsp.buf_request_sync(bufnr, vim.lsp.protocol.Methods.completionItem_resolve, completionItem, 500)
          if resolvedItem == nil then
            return
          end
          local docs = vim.tbl_get(resolvedItem[client.id], "result", "documentation", "value")
          if nil == docs then
            return
          end

          local winData = vim.api.nvim__complete_set(info["selected"], { info = docs })
          if not winData.winid or not vim.api.nvim_win_is_valid(winData.winid) then
            return
          end

          vim.api.nvim_win_set_config(winData.winid, { border = "rounded" })
          vim.treesitter.start(winData.bufnr, "markdown")
          vim.wo[winData.winid].conceallevel = 3
        end,
      })
    end
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
    keymap("<C-k>", vim.lsp.buf.signature_help, "signature help", "i")
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
