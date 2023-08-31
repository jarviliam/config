local fzf = require("fzf-lua")
local utils = require("core.utils")
local function nnoremap(key, fn, desc, opts) --{{{
  opts = vim.tbl_extend("force", { buffer = true, silent = true, desc = desc }, opts or {})
  vim.keymap.set("n", key, fn, opts)
end --}}}
local function xnoremap(key, fn, desc, opts) --{{{
  opts = vim.tbl_extend("force", { buffer = true, silent = true, desc = desc }, opts or {})
  vim.keymap.set("x", key, fn, opts)
end --}}}
local function inoremap(key, fn, desc, opts) --{{{
  opts = vim.tbl_extend("force", { buffer = true, silent = true, desc = desc }, opts or {})
  vim.keymap.set("i", key, fn, opts)
end --}}}

local function setup_diagnostics(bufnr)
  nnoremap("<localleader>dd", vim.diagnostic.open_float, "show diagnostics")
  nnoremap("<localleader>dq", vim.diagnostic.setqflist, "populate quickfix")
  nnoremap("<localleader>dw", vim.diagnostic.setloclist, "populate local list")
  
  -- stylua: ignore start
  local next = vim.diagnostic.goto_next
  local prev = vim.diagnostic.goto_prev
  local repeat_ok, ts_repeat_move = pcall(require, "nvim-treesitter.textobjects.repeatable_move")
  if repeat_ok then
    next, prev= ts_repeat_move.make_repeatable_move_pair(vim.diagnostic.goto_next, vim.diagnostic.goto_prev)
  end
  nnoremap("]d", function() utils.call_and_center(next) end, "goto next diagnostic")
  nnoremap("[d", function() utils.call_and_center(prev) end, "goto previous diagnostic")
  utils.buffer_command("DiagLoc", function() vim.diagnostic.setloclist() end)
  utils.buffer_command("DiagQf",  function() vim.diagnostic.setqflist()  end)

  local ok, diagnostics = pcall(require, "fzf-lua.providers.diagnostic")
  if ok then
    utils.buffer_command("Diagnostics",    function() diagnostics.diagnostics({}) end)
    utils.buffer_command("Diag",           function() diagnostics.diagnostics({}) end)
    utils.buffer_command("DiagnosticsAll", function() diagnostics.all({})         end)
    utils.buffer_command("DiagAll",        function() diagnostics.all({})         end)
  end
  -- stylua: ignore end
  utils.buffer_command("DiagnosticsDisable", function()
    vim.diagnostic.disable(bufnr)
  end)
  utils.buffer_command("DiagnosticsEnable", function()
    vim.diagnostic.enable(bufnr)
  end)
  vim.api.nvim_create_autocmd("CursorHold", {
    callback = require("plugins.lsp.diagnostic").hover,
    buffer = bufnr,
  })
end

return function(options)
  return function(client, bufnr)
    if client.supports_method("textDocument/completion") then
      vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
    end

    if client.supports_method("textDocument/definition") then
      local op = function()
        fzf.lsp_definitions({ jump_to_single_result = true })
      end
      utils.buffer_command("Definition", op)
      nnoremap("gd", op, "Go to definition")
      nnoremap("<leader>nd", op, "goto definition [LSP]")
      vim.bo.tagfunc = "v:lua.vim.lsp.tagfunc"
    end

    if client.supports_method("textDocument/hover") then
      nnoremap("H", vim.lsp.buf.hover, "Show hover")
      nnoremap("K", vim.lsp.buf.hover, "hover information [LSP]")
      inoremap("<M-h>", vim.lsp.buf.hover, "Show hover")
    end

    if client.supports_method("textDocument/signatureHelp") then
      nnoremap("K", vim.lsp.buf.signature_help, "signature help [LSP]")
      inoremap("<M-l>", vim.lsp.buf.signature_help, "signature help [LSP]")
      require("lsp_signature").on_attach({
        handler_opts = { border = "rounded" },
        hint_prefix = "",
        fixpos = true,
        padding = " ",
      }, bufnr)
    end

    if client.supports_method("textDocument/codeAction") then
      vim.keymap.set("n", "<leader>na", "<cmd>FzfLua lsp_code_actions", {
        desc = "lsp: code actions",
        winopts = {
          relative = "cursor",
          row = 1.01,
          col = 0,
          height = 0.20,
          width = 0.55,
        },
      })
    end
    if client.supports_method("textDocument/rename") then
      nnoremap("<leader>rn", vim.lsp.buf.rename, "lsp: rename")
    end

    if client.supports_method("workspace/symbol") then
      utils.buffer_command("WorkspaceSymbols", fzf.lsp_live_workspace_symbols)
    end

    if client.supports_method("textDocuments/documentSymbol") then
      local op = function()
        fzf.lsp_document_symbols({
          jump_to_single_result = true,
          fzf_opts = {
            ["--with-nth"] = "2..",
          },
        })
      end
      utils.buffer_command("DocumentSymbol", op)
      nnoremap("<localleader>@", op, "Documents symbol")
    end

    if client.supports_method("textDocument/references") then
      local op = function()
        fzf.lsp_references({ jump_to_single_result = true })
      end
      utils.buffer_command("References", op)
      nnoremap("gr", op, "Go to references")
      nnoremap("<localleader>nr", op, "goto reference [LSP]")
    end

    if client.supports_method("textDocument/implementation") then
      local op = function()
        fzf.lsp_implementations({ jump_to_single_result = true })
      end
      utils.buffer_command("Implementation", op)
      nnoremap("<localleader>gi", op, "Go to implementation")
      nnoremap("<localleader>ni", op, "goto implementation [LSP]")
    end

    if client.supports_method("textDocument/typeDefinition") then
      local op = function()
        fzf.lsp_typedefs({ jump_to_single_result = true })
      end
      utils.buffer_command("TypeDefinition", op)
      nnoremap("<leader>nt", op, "goto type definition [LSP]")
    end

    if client.supports_method("textDocument/declaration") then
      local op = function()
        fzf.lsp_declarations({ jump_to_single_result = true })
      end
      nnoremap("gD", op, "Go to declaration")
      nnoremap("<leader>nD", op, "goto declaration [LSP]")
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
        nnoremap("<localleader>cr", vim.lsp.codelens.run, "run code lens")
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI", "InsertLeave" }, {
          group = vim.api.nvim_create_augroup("code_lenses", { clear = true }),
          callback = vim.lsp.codelens.refresh,
          buffer = 0,
        })
      end
    end

    setup_diagnostics(bufnr)
  end
end
