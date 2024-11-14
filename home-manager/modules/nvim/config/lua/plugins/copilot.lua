local codeCompanion = true
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
    enabled = codeCompanion,
    cmd = {
      "CodeCompanion",
      "CodeCompanionChat",
      "CodeCompanionToggle",
      "CodeCompanionActions",
    },
    keys = {
      { "<leader>ap", "<cmd>CodeCompanionActions<CR>", desc = "Actions" },
      { "<leader>aq", "<cmd>CodeCompanionChat<CR>", desc = "New Chat" },
      { "<leader>aa", "<cmd>CodeCompanionChat Toggle<CR>", desc = "Toggle chat" },
      -- { "v", "ga", "<cmd>CodeCompanionChat Add<CR>", desc = "Add to chat" },
    },
    opts = {
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
