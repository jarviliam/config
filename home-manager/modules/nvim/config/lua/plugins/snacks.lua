---@type LazySpec[]
return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    -- stylua: ignore
    keys = {
      { "<leader>fu",function () Snacks.picker.undo() end, desc = "Undo"},
      { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit", },
      { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer", },
      { "<leader>z",  function() Snacks.zen() end, desc = "Toggle Zen Mode" },
      { "<leader>Z",  function() Snacks.zen.zoom() end, desc = "Toggle Zoom" },

      -- Windows
      { "<leader>N", desc = "Neovim News",
        function()
          Snacks.win({ file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1], width = 0.6,
            height = 0.6,
            wo = {
              spell = false,
              wrap = false,
              signcolumn = "yes",
              statuscolumn = " ",
              conceallevel = 3,
            },
          })
        end, },
      { "<C-/>", function() Snacks.terminal() end, desc = "Terminal", },
      -- Git
      { "<leader>go", function() Snacks.gitbrowse.open() end, mode = {"n","v"},desc = "Open Git URL" },
      { "<leader>gC", function()
          Snacks.gitbrowse({ open = function(url) vim.fn.setreg("+", url) end, notify = false })
      end, desc = "Copy Git URL" },

      -- Scratch
      { "<leader>pS", function() Snacks.profiler.scratch() end, desc = "Profiler Scratch Buffer", },
      { "<leader>.", function() Snacks.scratch() end, desc = "Toggle Scratch Buffer", },
    },
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true, notify = true },
      terminal = {
        enabled = true,
        shell = "zsh",
      },
      notifier = { enabled = true },
      quickfile = { enabled = true },
      explorer = {
        replace_netrw = true,
      },
      input = { enabled = true },
      scope = {
        enabled = true,
      },
      indent = {
        animate = {
          enabled = false,
        },
        indent = {
          enabled = true,
        },
      },
      statuscolumn = {
        enabled = true,
        left = { "git" },
        right = { "sign" },
        git = { patterns = { "GitSign" } },
      },
      dashboard = {
        enabled = true,
        preset = {
          --- @type snacks.dashboard.Item[]
          keys = {
            { icon = "󰁯 ", key = "l", desc = "Load Session", action = ":SessionLoad", label = "[l]" },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert", label = "[n]" },
            {
              icon = "󰱼 ",
              key = "f",
              desc = "Find File",
              action = ":FzfLua files",
              label = "[f]",
            },
            {
              icon = " ",
              key = "g",
              desc = "Find Text",
              action = ":FzfLua live_grep_glob",
              label = "[g]",
            },
            {
              icon = " ",
              key = "p",
              desc = "Profile Plugins",
              action = ":Lazy profile",
              enabled = package.loaded.lazy ~= nil,
              label = "[p]",
            },
            {
              icon = " ",
              key = "u",
              desc = "Update Plugins",
              action = ":Lazy sync",
              enabled = package.loaded.lazy ~= nil,
              label = "[u]",
            },
            { icon = " ", key = "q", desc = "Quit", action = ":qa!", label = "[q]" },
          },
        },
        sections = {
          {
            align = "center",
            text = { "[ Recent Files ]", hl = "Function" } --[[@as snacks.dashboard.Text]],
            padding = 1,
          },
          { section = "recent_files", indent = 1, padding = 1 },
          {
            align = "center",
            text = { string.rep("─", 50), hl = "FloatBorder" } --[[@as snacks.dashboard.Text]],
            padding = 1,
          },
          { section = "keys", indent = 1 },
          {
            align = "center",
            text = { string.rep("─", 50), hl = "FloatBorder" } --[[@as snacks.dashboard.Text]],
            padding = 1,
          },
          { section = "startup" },
        },
        width = 80,
      },
      words = { enabled = false },
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        once = true,
        callback = function()
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end
          vim.print = _G.dd

          Snacks.toggle.diagnostics():map("\\d")
          Snacks.toggle.inlay_hints():map("\\i")
          Snacks.toggle.line_number():map("\\n")
          Snacks.toggle.treesitter():map("\\t")
          Snacks.toggle.option("spell", { name = "Spelling" }):map("\\s")
          Snacks.toggle.option("wrap", { name = "Wrap" }):map("\\w")
          Snacks.toggle
            .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
            :map("\\c")
        end,
        vim.api.nvim_create_user_command("Notifications", function()
          Snacks.notifier.show_history()
        end, { desc = "Show Notification History" }),
      })
    end,
  },
}
