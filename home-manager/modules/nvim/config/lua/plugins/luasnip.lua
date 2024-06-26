return {
    "L3MON4D3/LuaSnip",
    event = "InsertEnter",
    enabled = false,
    dependencies = { "rafamadriz/friendly-snippets" },
    opts = function()
        local t = require("luasnip.util.types")
        local ft_functions = require("luasnip.extras.filetype_functions")
        return {
            history = true,
            updateevents = "TextChanged,TextChangedI",
            delete_check_events = "TextChanged",
            region_check_events = "CursorMoved",
            enable_autosnippets = true,
            store_selection_keys = "<Tab>",
            ft_func = ft_functions.from_filetype,
            ext_opts = {
                [t.choiceNode] = {
                    active = {
                        virt_text = { { "<-", "Error" } },
                    },
                },
            },
        }
    end,
    config = function(_, opts)
        local luasnip = require("luasnip")
        luasnip.setup(opts)
        require("luasnip.loaders.from_vscode").lazy_load()
        luasnip.filetype_extend("javascript", { "javascriptreact", "typescriptreact" })
        require("snippets")

        vim.keymap.set({ "i", "s" }, "<C-l>", function()
            if luasnip.expand_or_locally_jumpable() then
                luasnip.expand_or_jump()
            end
        end, { silent = true, desc = "jump forward or expand snippet" })

        vim.keymap.set({ "i", "s" }, "<C-h>", function()
            if luasnip.jumpable(-1) then
                luasnip.jump(-1)
            end
        end, { silent = true, desc = "jump backward in snippet" })

        vim.keymap.set({ "i", "s" }, "<C-c>", function()
            if luasnip.choice_active() then
                require 'luasnip.extras.select_choice' ()
            end
        end, { desc = "Select Choice" })

        vim.keymap.set({ "i", "s" }, "<C-j>", function()
            if luasnip.choice_active() then
                luasnip.change_choice(-1)
            end
        end, { silent = true, desc = "choose prev ChoiceNode" })
    end,
}
