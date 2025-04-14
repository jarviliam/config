local methods = vim.lsp.protocol.Methods

local function setupDiagnostics()
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
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
      focusable = true,
      source = "if_many",
      severity_sort = true,
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
end

--- Sets up the Keymaps and autocommands
---@param client vim.lsp.Client
---@param bufnr integer
local function onAttach(client, bufnr)
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
end

---@type LazySpec
return {
  "lsp",
  event = "LazyFile",
  config = function()
    vim.uv.fs_unlink(vim.lsp.get_log_path())
    vim.lsp.log.set_level(vim.lsp.log.levels.WARN)
    vim.lsp.log.set_format_func(vim.inspect)

    setupDiagnostics()

    vim.lsp.config("*", {
      capabilities = require("blink.cmp").get_lsp_capabilities({
        workspace = {
          didChangeWatchedFiles = {
            dynamicRegistration = true,
          },
        },
      }),
      root_markers = { ".git" },
    } --[[@as vim.lsp.Config]])

    vim
      .iter(vim.api.nvim_get_runtime_file("lsp/*.lua", true))
      :map(function(config_path)
        return vim.fs.basename(config_path):match("^(.*)%.lua$")
      end)
      :each(function(server_name)
        vim.lsp.enable(server_name)
      end)

    vim.api.nvim_create_autocmd("LspAttach", {
      desc = "Configure LSP Keymaps",
      callback = function(args)
        local _client = vim.lsp.get_client_by_id(args.data.client_id)
        if not _client then
          return
        end
        onAttach(_client, args.buf)
      end,
    })

    -- Update mappings when registering dynamic capabilities.
    local register_capability = vim.lsp.handlers[methods.client_registerCapability]
    vim.lsp.handlers[methods.client_registerCapability] = function(err, res, ctx)
      local client = vim.lsp.get_client_by_id(ctx.client_id)
      if not client then
        return
      end

      onAttach(client, vim.api.nvim_get_current_buf())

      return register_capability(err, res, ctx)
    end

    vim.api.nvim_create_user_command("LspLog", function()
      vim.cmd.tabnew(vim.lsp.get_log_path())
    end, { desc = "Open LSP log" })
  end,
  virtual = true,
}
