return {
  { "tpope/vim-sleuth", event = "BufReadPre" },
  {
    "MagicDuck/grug-far.nvim",
    opts = { headerMaxWidth = 80 },
    cmd = "GrugFar",
    keys = {
      {
        "<leader>s/",
        function()
          local grug = require("grug-far")
          local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
          grug.open({
            transient = true,
            prefills = {
              filesFilter = ext and ext ~= "" and "*." .. ext or nil,
            },
          })
        end,
        mode = { "n", "v" },
        desc = "Search and Replace",
      },
    },
  },
  {
    "chrisgrieser/nvim-tinygit",
    enabled = false,
    opts = {
      commitMsg = {
        conventionalCommits = {
          enforce = true,
        },
      },
    },
  },
  {
    "chrisgrieser/nvim-rulebook",
        -- stylua: ignore
        keys = {
            { "<leader>ri", function() require("rulebook").ignoreRule() end, desc = "Ignore" },
            { "<leader>rl", function() require("rulebook").lookupRule() end, desc = "Look Up" },
            { "<leader>ry", function() require("rulebook").yankDiagnosticCode() end, desc = "Yank Diagnostic" },
        },
  },
  {
    "folke/trouble.nvim",
    cmd = { "Trouble" },
    keys = {
            -- stylua: ignore
            { "<leader>xx", function() require("trouble").toggle({ mode = "diagnostics" }) end, desc = "Trouble" },
    },
    opts = {
      auto_preview = false,
      focus = true,
      modes = {
        lsp_references = {
          params = {
            include_declaration = false,
          },
        },
      },
    },
  },
}
