return {
  "olimorris/codecompanion.nvim",
  cmd = {
    "CodeCompanion",
    "CodeCompanionChat",
    "CodeCompanionToggle",
    "CodeCompanionActions",
  },
  keys = {
    -- stylua: ignore start
    { "<leader>aa", "<cmd>CodeCompanionActions<CR>", desc = "Actions" },
    { "<leader>aq", "<cmd>CodeCompanionChat<CR>", desc = "New Chat" },
    { "<leader>ac", "<cmd>CodeCompanionChat Toggle<CR>", desc = "Toggle chat" },
    { "<leader>ad", function() require("codecompanion").prompt("doc") end, mode = "v", desc = "Documentation"},
    { "<leader>al", function() require("codecompanion").prompt("lsp") end, mode = "v", desc = "LSP Diag"},
    { "<leader>af", function() require("codecompanion").prompt("fix") end, mode = "v", desc = "Fix Code"},
    { "<leader>ap", function() require("codecompanion").prompt("pr") end, desc = "Pull Request"},
    { "<leader>ao", function() require("codecompanion").prompt("optimize") end, mode = "v", desc = "Optimize"},
    { "<leader>ar", function() require("codecompanion").prompt("refactor") end, mode = "v", desc = "Refactor"},
    { "<leader>at", function() require("codecompanion").prompt("tests") end, mode = "v",desc = "Generate Tests" },
    { "<leader>aw", function() require("codecompanion").prompt("workflow") end, desc = "Code Workflow" },
    -- stylua: ignore end
    {
      "<leader>aq",
      function()
        if vim.tbl_contains({ "v", "V", "x" }, vim.fn.mode()) then
          vim.ui.input({ prompt = "CodeCompanion: " }, function(input)
            if input then
              vim.cmd("'<,'>CodeCompanion " .. input)
            end
          end)
        else
          vim.ui.input({ prompt = "CodeCompanion: " }, function(input)
            if input then
              vim.cmd.CodeCompanion(input)
            end
          end)
        end
      end,
      desc = "Prompt (CodeCompanion)",
      mode = { "n", "v", "x" },
    },
  },
  opts = {
    display = {
      chat = {
        intro_message = "",
        window = {
          layout = "vertical", ---@type "float"|"vertical"|"horizontal"|"buffer"
          position = "right", ---@type "left"|"right"|"top"|"bottom"
          width = 0.4,
        },
      },
      diff = {
        layout = "vertical", ---@type "horizontal"|"vertical"
        provider = "default", ---@type "default"|"mini_diff"
      },
      inline = {
        layout = "vertical", ---@type "vertical"|"horizontal"|"buffer"
      },
    },
    prompt_library = {
      ["Optimize"] = require("plugins.ai.prompts.optimize"),
      ["Pull Request"] = require("plugins.ai.prompts.pr"),
      ["Refactor"] = require("plugins.ai.prompts.refactor"),
      ["Documentation"] = require("plugins.ai.prompts.documentation"),
    },
    adapters = {
      copilot = function()
        return require("codecompanion.adapters").extend("copilot", {
          schema = {
            ---@see https://github.com/copilot
            model = {
              default = "o3-mini-2025-01-31",
              max_tokens = {
                default = 8192,
              },
            },
          },
        })
      end,
    },
    strategies = {
      chat = {
        adapter = "copilot",
        slash_commands = {
          buffer = { opts = { provider = "fzf_lua" } },
          file = { opts = { provider = "fzf_lua" } },
          help = { opts = { provider = "fzf_lua" } },
          symbols = { opts = { provider = "fzf_lua" } },
        },
      },
      inline = {
        adapter = "copilot",
      },
      agent = {
        adapter = "copilot",
      },
    },
  },
  config = function(_, opts)
    require("codecompanion").setup(opts)
  end,
}
