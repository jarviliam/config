return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    -- stylua: ignore
    keys = { { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit", },
      { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer", },
      -- Words
      { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "snacks: goto next reference", },
      { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "snacks: goto prev reference", },

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
      { [[<C-/>]], function() Snacks.terminal.toggle(vim.env.SHELL) end, mode = { "n", "t" }, desc = "Terminal", },
      -- Git
      { "<leader>go", function() Snacks.gitbrowse.open() end, desc = "Open Git URL" },
      { "<leader>gC", function()
          Snacks.gitbrowse({ open = function(url) vim.fn.setreg("+", url) end, notify = false })
      end, desc = "Copy Git URL" },

      -- Scratch
      { "<leader>pS", function() Snacks.profiler.scratch() end, desc = "Profiler Scratch Buffer", },
      { "<leader>.", function() Snacks.scratch() end, desc = "Toggle Scratch Buffer", },
    },
    opts = {
      bigfile = { enabled = true },
      notifier = { enabled = true },
      quickfile = { enabled = true },
      input = { enabled = true },
      indent = {
        enabled = true,
        animate = {
          enabled = false,
        },
        scope = {
          enabled = true,
        },
      },
      statuscolumn = {
        enabled = true,
        left = { "git" },
        right = { "sign" },
        git = { patterns = { "GitSign" } },
      },
      dashboard = { enabled = true, example = "github" },
      words = { enabled = true },
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
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
