return {
  {
    "olimorris/codecompanion.nvim",
    cmd = {
      "CodeCompanion",
      "CodeCompanionChat",
      "CodeCompanionToggle",
      "CodeCompanionActions",
      "CodeCompanionHistory",
    },
    keys = {
      -- stylua: ignore start
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
    opts = {},
    config = function(_, opts) end,
  },
}
