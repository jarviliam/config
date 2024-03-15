local fzf = require("fzf-lua")
local diagnostic_icons = require("icons").diagnostics
local methods = vim.lsp.protocol.Methods

local M = {}

fzf.lsp_code_actions()
M.client_capabilities = function()
    return vim.tbl_deep_extend('force', vim.lsp.protocol.make_client_capabilities(), require('lsp_compl').capabilities())
end

--- Sets up the Keymaps and autocommands
---@param client vim.lsp.Client
---@param bufnr integer
local function on_attach(client, bufnr)
    ---@param lhs string
    ---@param rhs string|function
    ---@param opts string|table
    ---@param mode? string|string[]
    local function keymap(lhs, rhs, opts, mode)
        opts = type(opts) == 'string' and { desc = opts }
            or vim.tbl_extend('error', opts --[[@as table]], { buffer = bufnr })
        mode = mode or 'n'
        mode = mode or "n"
        vim.keymap.set(mode, lhs, rhs, opts)
    end

    --- @param keys string
    local function feedkeys(keys)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), 'n', true)
    end

    local function pumvisible()
        return tonumber(vim.fn.pumvisible()) ~= 0
    end

    if client.server_capabilities.signatureHelpProvider then
        client.server_capabilities.signatureHelpProvider.triggerCharacters = {}
    end

    local lsp_compl = require 'lsp_compl'
    lsp_compl.attach(client, bufnr, { server_side_fuzzy_completion = true })

    keymap('<cr>', function()
        return lsp_compl.accept_pum() and '<C-y>' or '<cr>'
    end, { expr = true }, 'i')

    keymap('/', function()
        return pumvisible() and '<C-e>' or '/'
    end, { expr = true }, 'i')

    keymap('<C-n>', function()
        if pumvisible() then
            feedkeys '<C-n>'
        else
            if next(vim.lsp.get_clients { bufnr = 0 }) then
                lsp_compl.trigger_completion()
            else
                if vim.bo.omnifunc == '' then
                    feedkeys '<C-x><C-n>'
                else
                    feedkeys '<C-x><C-o>'
                end
            end
        end
    end, 'Trigger/select next completion', 'i')

    keymap('<Tab>', function()
        local luasnip = require 'luasnip'
        if pumvisible() then
            feedkeys '<C-n>'
        elseif luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
        else
            feedkeys '<Tab>'
        end
    end, {}, { 'i', 's' })

    keymap('<S-Tab>', function()
        local luasnip = require 'luasnip'

        if pumvisible() then
            feedkeys '<C-p>'
        elseif luasnip.expand_or_locally_jumpable(-1) then
            luasnip.jump(-1)
        else
            feedkeys '<S-Tab>'
        end
    end, {}, { 'i', 's' })


    keymap("gr", function()
        fzf.lsp_references({ jump_to_single_result = true })
    end, "Go to references")
    keymap("<leader>gy", "<cmd>FzfLua lsp_typedefs<cr>", "goto type definition [LSP]")


    if client.supports_method(methods.textDocument_implementation) then
        local op = function() fzf.lsp_implementations({ jump_to_single_result = true }) end
        keymap("<leader>gi", op, "Go to implementation")
        keymap("<leader>ni", op, "goto implementation [LSP]")
    end


    keymap("K", vim.lsp.buf.hover, "Hover")
    keymap("<leader>fs", fzf.lsp_document_symbols, "Documents symbol")
    keymap("<leader>fS", function()
        fzf.lsp_live_workspace_symbols({ no_header_i = true })
    end, "Workspace symbols")

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

    if client.supports_method(methods.textDocument_definition) then
        keymap("gd", function()
            fzf.lsp_definitions({ jump_to_single_result = true })
        end, "Go to definition")
        keymap("gD", fzf.lsp_definitions, "Peek definition")
    end

    if client.supports_method(methods.textDocument_signatureHelp) then
        keymap("<C-k>",
            function()
                if pumvisible() then
                    feedkeys '<C-e>'
                end
                vim.lsp.buf.signature_help()
            end, "signature help", "i")
        -- require("lsp_signature").on_attach({
        --     handler_opts = { border = "rounded" },
        --     hint_prefix = "",
        --     fixpos = true,
        --     padding = " ",
        -- }, bufnr)
    end

    if client.supports_method(methods.textDocument_documentHighlight) then
        local hl_group = vim.api.nvim_create_augroup('jarviliam/cursor_highlights', { clear = false })
        vim.api.nvim_create_autocmd({ 'CursorHold', 'InsertLeave', 'BufEnter' },
            {
                group = hl_group,
                desc = 'Highlight references under cursor',
                buffer = bufnr,
                callback = vim.lsp.buf
                    .document_highlight
            })
        vim.api.nvim_create_autocmd({ 'CursorMoved', 'InsertEnter', 'BufLeave' },
            {
                group = hl_group,
                desc = 'Clear highlight references',
                buffer = bufnr,
                callback = vim.lsp.buf
                    .clear_references
            })
    end

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
end

vim.diagnostic.config({
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = diagnostic_icons.ERROR,
            [vim.diagnostic.severity.WARN] = diagnostic_icons.WARN,
            [vim.diagnostic.severity.HINT] = diagnostic_icons.HINT,
            [vim.diagnostic.severity.INFO] = diagnostic_icons.INFO,
        }
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
    end
})

return M
