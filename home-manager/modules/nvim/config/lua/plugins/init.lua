local conf = require("conf")


local function open_and_close()
    local overseer = require 'overseer'

    -- Open the task window.
    overseer.open { enter = false }

    -- Close it after 10 seconds (if not inside the window).
    vim.defer_fn(function()
        if vim.bo.filetype ~= 'OverseerList' then
            overseer.close()
        end
    end, 10 * 1000)
end

return {
    "nvim-lua/plenary.nvim",
    "b0o/SchemaStore.nvim",
    {
        "kyazdani42/nvim-web-devicons",
        opts = { default = true },
    },
    {
        "ibhagwan/fzf-lua",
        cmd = "FzfLua",
        lazy = false,
        keys = {
            { "<leader>ff", "<cmd>FzfLua files<cr>",          desc = "Find File" },
            { "<leader>/",  "<cmd>FzfLua live_grep_glob<cr>", desc = "Live grep" },
            { "<leader>fm", "<cmd>FzfLua marks<cr>",          desc = "marks" },
            { "<leader>f?",  "<cmd>FzfLua builtin<cr>",        desc = "builtin" },
            { "<leader>fM", "<cmd>FzfLua man_pages<cr>",      desc = "man_pages" },
            { "<leader>fw", "<cmd>FzfLua grep_cword<cr>",     desc = "grep <word> (project)" },
            { "<leader>fW", "<cmd>FzfLua grep_cWORD<cr>",     desc = "grep <WORD> (project)" },
            { "<leader>fz", "<cmd>FzfLua spell_suggest<cr>",  desc = "spell" },
            { "<leader>fg", "<cmd>FzfLua git_files<cr>",      desc = "Find Files (Git)" },
            { "<leader>f/", "<cmd>FzfLua lgrep_curbuf<cr>",   desc = "live grep (buffer)" },
            { "<leader>fj", "<cmd>FzfLua jumps<cr>",          desc = "jumps" },
            { "<leader>fr", "<cmd>FzfLua resume<cr>",         desc = "resume" },
            { "<leader>gc", "<Cmd>FzfLua git_commits<CR>",    desc = "commits" },
            { "<leader>gC", "<Cmd>FzfLua git_bcommits<CR>",   desc = "commits (buffer)" },
            { "<leader>gb", "<Cmd>FzfLua git_branches<CR>",   desc = "branches" },
            { "<leader>fb", "<cmd>FzfLua buffers<cr>",          desc = "Buffers" },
        },
        opts = function()
            local actions = require("fzf-lua.actions")
            return {
                "fzf-native",
                fzf_colors = {
                    bg = { "bg", "Normal" },
                    gutter = { "bg", "Normal" },
                    info = { "fg", "Conditional" },
                    scrollbar = { "bg", "Normal" },
                    separator = { "fg", "Comment" },
                },
                fzf_opts = {
                    ["--info"] = "default",
                    ["--layout"] = "reverse-list",
                },
                helptags = {
                    actions = {
                        -- Open help pages in a vertical split.
                        ["default"] = actions.help_vert,
                    },
                },
                lsp = {
                    code_actions = {
                        previewer = "codeaction_native",
                        preview_pager =
                        "delta --side-by-side --width=$FZF_PREVIEW_COLUMNS --hunk-header-style='omit' --file-style='omit'",
                    },
                },
            }
        end,
    },
    {
        "mbbill/undotree",
        branch = "search",
        cmd = "UndotreeToggle",
        keys = { { mode = "n", "<leader>u", ":UndotreeToggle<CR>", { silent = true } }, },
        init = function()
            vim.g.undotree_CustomUndotreeCmd = "vertical 40 new"
            vim.g.undotree_CustomDiffpanelCmd = "botright 15 new"
        end,
    },
    {
        "creativenull/efmls-configs-nvim",
        version = "v1.4.0",
        dependencies = { "neovim/nvim-lspconfig" },
    },
    {
        "rcarriga/nvim-notify",
        init = function()
            local notify = require("notify")
            vim.notify = notify
        end,
        opts = {
            timeout = 2000,
            top_down = false,
            max_width = function()
                return math.floor(vim.o.columns * 0.75)
            end,
        },
    },
    {
        'stevearc/overseer.nvim',
        opts = {
            dap = false,
            templates = {
                'builtin',
            },
            form = {
                win_opts = { winblend = 0 },
            },
            confirm = {
                win_opts = { winblend = 5 },
            },
            task_win = {
                win_opts = { winblend = 5 },
            },
        },
        keys = {
            {
                '<leader>ot',
                '<cmd>OverseerToggle<cr>',
                desc = 'Toggle task window',
            },
            {
                '<leader>o<',
                function()
                    local overseer = require 'overseer'

                    local tasks = overseer.list_tasks { recent_first = true }
                    if vim.tbl_isempty(tasks) then
                        vim.notify('No tasks found', vim.log.levels.WARN)
                    else
                        overseer.run_action(tasks[1], 'restart')
                        open_and_close()
                    end
                end,
                desc = 'Restart last task',
            },
            {
                '<leader>or',
                function()
                    require('overseer').run_template({}, function(task)
                        if task then
                            open_and_close()
                        end
                    end)
                end,
                desc = 'Run task',
            },
        },
    },
    {
        "m4xshen/hardtime.nvim",
        dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
        opts = {},
        cmd = { "Hardtime" },
    },
    { "sainnhe/sonokai",          lazy = conf.theme ~= "sonokai",   dev = true },
    { "sainnhe/edge",             lazy = conf.theme ~= "edge" },
    { "sainnhe/everforest",       lazy = conf.theme ~= "everforest" },
    { "sainnhe/gruvbox-material", lazy = false },
}
