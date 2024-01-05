local fzf = require("fzf-lua")
local utils = require("core.utils")
local methods = vim.lsp.protocol.Methods

return function(_)
  return function(client, bufnr)
    ---@param lhs string
    ---@param rhs string|function
    ---@param desc string
    ---@param mode? string|string[]
    local function keymap(lhs, rhs, desc, mode)
      mode = mode or "n"
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
    end

    if client.supports_method(methods.textDocument_definition) then
      keymap("gd", function()
        fzf.lsp_definitions({ jump_to_single_result = true })
      end, "Go to definition")
      keymap("gD", fzf.lsp_definitions, "Peek definition")
    end

    keymap("K", vim.lsp.buf.hover, "hover information [LSP]")

    if client.supports_method(methods.textDocument_signatureHelp) then
      keymap("<C-k>", vim.lsp.buf.signature_help, "signature help", "i")
      require("lsp_signature").on_attach({
        handler_opts = { border = "rounded" },
        hint_prefix = "",
        fixpos = true,
        padding = " ",
      }, bufnr)
    end

    if client.supports_method(methods.textDocument_codeAction) then
      keymap("<leader>ca", function()
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

    keymap("<leader>cr", vim.lsp.buf.rename, "lsp: rename")

    keymap("<leader>fs", fzf.lsp_document_symbols, "Documents symbol")
    keymap("<leader>fS", fzf.lsp_live_workspace_symbols, "Workspace symbols")

    if client.supports_method(methods.textDocument_references) then
      keymap("gr", function()
        fzf.lsp_references({ jump_to_single_result = true })
      end, "Go to references")
    end

    if client.supports_method(methods.textDocument_implementation) then
      local op = function()
        fzf.lsp_implementations({ jump_to_single_result = true })
      end
      keymap("<localleader>gi", op, "Go to implementation")
      keymap("<localleader>ni", op, "goto implementation [LSP]")
    end

    if client.supports_method(methods.textDocument_typeDefinition) then
      local op = function()
        fzf.lsp_typedefs({ jump_to_single_result = true })
      end
      keymap("<leader>gy", op, "goto type definition [LSP]")
    end
    vim.keymap.set("n", "<leader>cf", function()
      vim.lsp.buf.format({ async = true })
    end, { silent = true, buffer = bufnr, desc = "Format" })

    local lsp_fmt_group = vim.api.nvim_create_augroup("LspFormattingGroup", {})
    vim.api.nvim_create_autocmd("BufWritePost", {
      group = lsp_fmt_group,
      callback = function(ev)
        local efm = vim.lsp.get_active_clients({ name = "efm", bufnr = ev.buf })
        if vim.tbl_isempty(efm) then
          return
        end
        vim.lsp.buf.format({ name = "efm" })
      end,
    })

    if client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
      local inlay_hints_group = vim.api.nvim_create_augroup("Toggle_Inlay_Hints", { clear = false })

      vim.defer_fn(function()
        local mode = vim.api.nvim_get_mode().mode
        vim.lsp.inlay_hint.enable(bufnr, mode == "n" or mode == "v")
      end, 500)
      vim.api.nvim_create_autocmd("InsertEnter", {
        group = inlay_hints_group,
        desc = "Enable inlay hints",
        buffer = bufnr,
        callback = function()
          vim.lsp.inlay_hint.enable(bufnr, false)
        end,
      })
      vim.api.nvim_create_autocmd("InsertLeave", {
        group = inlay_hints_group,
        desc = "Disable inlay hints",
        buffer = bufnr,
        callback = function()
          vim.lsp.inlay_hint.enable(bufnr, true)
        end,
      })
    end

    if client.supports_method(methods.textDocument_codeLens) or client.supports_method(methods.codeLens_resolve) then
      if not utils.buffer_has_var("code_lens") then
        utils.buffer_command("CodeLensRefresh", vim.lsp.codelens.refresh)
        utils.buffer_command("CodeLensRun", vim.lsp.codelens.run)
        keymap("<localleader>cr", vim.lsp.codelens.run, "run code lens")
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI", "InsertLeave" }, {
          group = vim.api.nvim_create_augroup("code_lenses", { clear = true }),
          callback = vim.lsp.codelens.refresh,
          buffer = 0,
        })
      end
    end

    keymap("<leader>cd", vim.diagnostic.open_float, "line diagnostics")
    local next = vim.diagnostic.goto_next
    local prev = vim.diagnostic.goto_prev
    local repeat_ok, ts_repeat_move = pcall(require, "nvim-treesitter.textobjects.repeatable_move")
    if repeat_ok then
      next, prev = ts_repeat_move.make_repeatable_move_pair(vim.diagnostic.goto_next, vim.diagnostic.goto_prev)
    end
    keymap("[d", prev, "Previous diagnostic")
    keymap("]d", next, "Next diagnostic")
    keymap("[e", function()
      prev({ severity = vim.diagnostic.severity.ERROR })
    end, "Previous error")
    keymap("]e", function()
      next({ severity = vim.diagnostic.severity.ERROR })
    end, "Next error")
    -- Disable for now
    -- vim.api.nvim_create_autocmd("CursorHold", {
    --   callback = require("plugins.lsp.diagnostic").hover,
    --   buffer = bufnr,
    -- })
  end
end
