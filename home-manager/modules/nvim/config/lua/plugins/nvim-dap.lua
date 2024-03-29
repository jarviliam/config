return {
    "mfussenegger/nvim-dap",
    dependencies = {
        {
            "rcarriga/nvim-dap-ui",
            keys = {
                {
                    "<leader>de",
                    function()
                        require("dapui").eval()
                        require("dapui").eval()
                    end,
                    desc = "Evaluate expression",
                },
            },
            opts = {
                icons = {
                    collapsed = " ",
                    expanded = " ",
                    current = " ",
                    folder_empty = "",
                    folder_closed = "",
                    folder_open = "",
                    file = "",
                    v_border = "▐",
                },
                floating = {
                    border = "rounded",
                },
                layouts = {
                    {
                        elements = {
                            { id = "stacks",      size = 0.30 },
                            { id = "breakpoints", size = 0.20 },
                            { id = "scopes",      size = 0.50 },
                        },
                        position = "left",
                        size = 40,
                    },
                },
            },
        },
        { "theHamsta/nvim-dap-virtual-text", opts = { virt_text_pos = "eol" } },
        "leoluz/nvim-dap-go",
        "mfussenegger/nvim-dap-python",
        {
            "jbyuki/one-small-step-for-vimkind",
            keys = {
                {
                    "<leader>dl",
                    function()
                        require("osv").launch({ port = 8086 })
                    end,
                    desc = "Launch Lua adapter",
                },
            },
        },
    },
    lazy = true,
    keys = {
        { "<Space>db", "<cmd>DapToggleBreakpoint<cr>",    desc = "Toggle Breakpoint" },
        { "<Space>dB", "<cmd>FzfLua dap_breakpoints<cr>", desc = "List Breakpoint" },
        {
            "<Space>dc",
            "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
            desc = "Set Breakpoint",
        },
        { "<F5>",      "<cmd>DapContinue<cr>",                  desc = "Continue" },
        { "<Space>df", "<cmd>lua require 'dapui'.toggle()<CR>", desc = "Toggle" },
    },
    config = function()
        local lang = {
            "cpp",
            "go",
            "go_test",
            "python",
            "node",
        }
        for _, l in pairs(lang) do
            local fname = string.format("plugins.dap.%s", l)
            require(fname)
        end
        local dap = require("dap")
        dap.listeners.after.event_stopped["jarviliam"] = function()
            vim.keymap.set("n", "<leader>dh", "<cmd>lua require 'dap.ui.widgets'.hover()<CR>", { desc = "Hover" })
            vim.keymap.set("v", "<leader>dh", "<cmd>lua require 'dap.ui.widgets'.visual_hover()<CR>")
            vim.keymap.set("n", "<leader>dj", dap.step_into, { desc = "dap: Step Into" })
            vim.keymap.set("n", "<leader>dl", dap.step_over, { desc = "dap: Step Over" })
            vim.keymap.set("n", "<leader>dk", dap.step_out, { desc = "dap: Step Out" })
            vim.keymap.set("n", "<leader>dn", dap.run_to_cursor, { desc = "dap: Run To Cursor" })
        end

        require('overseer').patch_dap(true)
        require('dap.ext.vscode').json_decode = require('overseer.json').decode

        -- Lua configurations.
        dap.adapters.nlua = function(callback, config)
            callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
        end
        dap.configurations["lua"] = {
            {
                type = "nlua",
                request = "attach",
                name = "Attach to running Neovim instance",
            },
        }
        -- C configurations.
        dap.adapters.codelldb = {
            type = 'server',
            host = 'localhost',
            port = '${port}',
            executable = {
                command = 'codelldb',
                args = { '--port', '${port}' },
            },
        }

        -- Add configurations from launch.json
        require('dap.ext.vscode').load_launchjs(nil, {
            ['codelldb'] = { 'c' },
        })
    end,
}
