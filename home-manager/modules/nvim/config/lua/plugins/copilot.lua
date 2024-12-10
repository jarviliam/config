return {
  {
    {
      "github/copilot.vim",
      cmd = "Copilot",
      build = ":Copilot auth",
      opts = {
        suggestion = { enabled = false },
        panel = { enabled = false },
        filetypes = {
          markdown = true,
          help = true,
        },
      },
    },
  },
  {
    "olimorris/codecompanion.nvim",
    cmd = {
      "CodeCompanion",
      "CodeCompanionChat",
      "CodeCompanionToggle",
      "CodeCompanionActions",
    },
    keys = {
      { "<leader>aa", "<cmd>CodeCompanionActions<CR>", desc = "Actions" },
      { "<leader>aq", "<cmd>CodeCompanionChat<CR>", desc = "New Chat" },
      { "<leader>ac", "<cmd>CodeCompanionChat Toggle<CR>", desc = "Toggle chat" },
      {
        "<leader>ad",
        function()
          require("codecompanion").prompt("lsp")
        end,
        mode = { "n", "x" },
        desc = "Debug Diagnostics",
      },
      {
        "<leader>af",
        function()
          require("codecompanion").prompt("fix")
        end,
        mode = { "n", "x" },
        desc = "Fix Code",
      },
      {
        "<leader>ao",
        function()
          require("codecompanion").prompt("optimize")
        end,
        mode = { "n", "x" },
        desc = "Optimize",
      },
      -- { "v", "ga", "<cmd>CodeCompanionChat Add<CR>", desc = "Add to chat" },
    },
    opts = {
      -- adapters = {
      --   copilot = function()
      --     return require("codecompanion.adapters").extend("copilot", {
      --       schema = {
      --         model = {
      --           default = "claude-3.5-sonnet",
      --         },
      --       },
      --     })
      --   end,
      -- },
      strategies = {
        chat = {
          adapter = "copilot",
        },
        inline = {
          adapter = "copilot",
        },
        agent = {
          adapter = "copilot",
        },
      },
    },
  },
}
