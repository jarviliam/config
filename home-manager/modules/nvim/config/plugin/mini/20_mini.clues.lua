Config.later(function()
  local clue = require("mini.clue")

  clue.setup({
    window = {
      delay = 400,
      config = function(bufnr)
        local max_width = 0
        for _, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)) do
          max_width = math.max(max_width, vim.fn.strchars(line))
        end
        -- Keep some right padding.
        max_width = max_width + 2
        return {
          width = math.min(70, max_width),
        }
      end,
    },
    triggers = {
      -- Leader triggers
      { mode = { "n", "x" }, keys = "<Leader>" },
      { mode = "n", keys = [[\]] }, -- mini.basics

      -- Built-in completion
      { mode = "i", keys = "<C-x>" },

      -- `g` key
      { mode = { "n", "x" }, keys = "g" },

      -- Marks
      { mode = { "n", "x" }, keys = "'" },
      { mode = { "n", "x" }, keys = "`" },

      -- Registers
      { mode = { "n", "x" }, keys = '"' },
      { mode = { "i", "c" }, keys = "<C-r>" },
      -- Window commands
      { mode = "n", keys = "<C-w>" },
      { mode = { "n", "x" }, keys = "s" }, -- mini.surround
      -- `z` key
      { mode = { "n", "x" }, keys = "z" },
      { mode = { "n", "x" }, keys = "[" }, -- mini.bracketed
      { mode = { "n", "x" }, keys = "]" },
    },
    clues = {
      Config.leader_group_clues,
      clue.gen_clues.builtin_completion(),
      clue.gen_clues.g(),
      clue.gen_clues.marks(),
      clue.gen_clues.registers(),
      clue.gen_clues.windows(),
      clue.gen_clues.z(),
      clue.gen_clues.square_brackets(),
    },
  })
end)
