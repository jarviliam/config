---@type LazySpec
return {
  "chrisgrieser/nvim-rulebook",
  -- stylua: ignore
  keys = {
      { "<leader>ri", function() require("rulebook").ignoreRule() end, desc = "Ignore" },
      { "<leader>rl", function() require("rulebook").lookupRule() end, desc = "Look Up" },
      { "<leader>ry", function() require("rulebook").yankDiagnosticCode() end, desc = "Yank Diagnostic" },
  },
  ---@type rulebook.config
  opts = {},
}
