local fzf = require("fzf-lua")
local utils = require("core.utils")

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

    if client.supports_method("textDocument/definition") then
      keymap("gd", function ()
      fzf.lsp_definitions({ jump_to_single_result = true })end, "Go to definition")
      keymap("gD", fzf.lsp_definitions, "Peek definition")
    end

    if client.supports_method("textDocument/hover") then
      keymap("H", vim.lsp.buf.hover, "Show hover")
      -- nnoremap("K", vim.lsp.buf.hover, "hover information [LSP]")
      keymap("<M-h>", vim.lsp.buf.hover, "Show hover", "i")
    end

    if client.supports_method("textDocument/signatureHelp") then
      keymap("<C-k>", vim.lsp.buf.signature_help, "signature help", "i")
      require("lsp_signature").on_attach({
        handler_opts = { border = "rounded" },
        hint_prefix = "",
        fixpos = true,
        padding = " ",
      }, bufnr)
    end

    if client.supports_method("textDocument/codeAction") then
      keymap(
        "<leader>ca",function ()
        fzf.lsp_code_actions({
          winopts = {
            relative = "cursor",
            row = 1.01,
            col = 0,
            height = 0.20,
            width = 0.55,
          },
        })
        end
                    ,
        "lsp: code actions"
      )
    end

    keymap("<leader>rn", vim.lsp.buf.rename, "lsp: rename")

    if client.supports_method("workspace/symbol") then
      utils.buffer_command("WorkspaceSymbols", fzf.lsp_live_workspace_symbols)
    end

    if client.supports_method("textDocument/documentSymbol") then
      keymap("<leader>@", fzf.lsp_document_symbols, "Documents symbol")
    end

    if client.supports_method("textDocument/references") then
      keymap("gr", function()fzf.lsp_references({ jump_to_single_result = true })end, "Go to references")
    end

    if client.supports_method("textDocument/implementation") then
      local op = function()
        fzf.lsp_implementations({ jump_to_single_result = true })
      end
      keymap("<localleader>gi", op, "Go to implementation")
      keymap("<localleader>ni", op, "goto implementation [LSP]")
    end

    if client.supports_method("textDocument/typeDefinition") then
      local op = function()
        fzf.lsp_typedefs({ jump_to_single_result = true })
      end
      keymap("<leader>nt", op, "goto type definition [LSP]")
    end

    if client.supports_method("textDocument/declaration") then
      local op = function()
        fzf.lsp_declarations({ jump_to_single_result = true })
      end
      keymap("gD", op, "Go to declaration")
      keymap("<leader>nD", op, "goto declaration [LSP]")
    end

    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_buf_set_var(bufnr, "format_with_lsp", true)
      vim.keymap.set(
        "n",
        "<leader>lf",
        [[<cmd>lua vim.lsp.buf.format({async=true})<CR>]],
        { silent = true, buffer = bufnr, desc = "format document [null-ls]" }
      )
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({
            timeout_ms = 2000,
            bufnr = bufnr,
          })
        end,
      })
    end

    if client.supports_method("textDocument/codeLens") or client.supports_method("codeLens/resolve") then
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
    keymap("]d", function()
      utils.call_and_center(next)
    end, "Next diagnostic")
    keymap("[d", function()
      utils.call_and_center(prev)
    end, "Previous diagnostic")
    vim.api.nvim_create_autocmd("CursorHold", {
      callback = require("plugins.lsp.diagnostic").hover,
      buffer = bufnr,
    })
  end
end
