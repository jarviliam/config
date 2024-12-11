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
    },
    opts = {
      prompt_library = {
        ["Optimize"] = {
          strategy = "chat",
          description = "Optimize the selected code",
          opts = {
            mapping = "<leader>ao",
            modes = { "v" },
            short_name = "optimize",
            auto_submit = true,
            stop_context_insertion = true,
            user_prompt = false,
          },
          prompts = {
            {
              role = "system",
              content = function(context)
                return "I want you to act as a senior "
                  .. context.filetype
                  .. " developer. I will ask you specific questions and I want you to return concise explanations"
                  .. " and codeblock examples."
              end,
              opts = {
                visible = false,
              },
            },
            {
              role = "user",
              contains_code = true,
              content = function(context)
                local text = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

                return "Optimize the following code:\n\n```" .. context.filetype .. "\n" .. text .. "\n```\n\n"
              end,
            },
          },
        },
      },
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
