return {
  {
    "echasnovski/mini.comment",
    event = "VeryLazy",
    opts = {
      options = {
        custom_commentstring = function()
          return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
        end,
      },
    },
  },
  {
    "echasnovski/mini.jump",
    branch = "stable",
    event = "BufReadPre",
    opts = {
      mappings = {
        forward = "f",
        backward = "F",
        forward_till = "t",
        backward_till = "T",
        repeat_jump = "",
      },
    },
  },
  {
    "echasnovski/mini.bufremove",
    keys = {
      {
        "<leader>bd",
        function()
          require("mini.bufremove").delete(0, false)
        end,
        desc = "Delete Buffer",
      },
      {
        "<leader>bD",
        function()
          require("mini.bufremove").delete(0, true)
        end,
        desc = "Delete Buffer (Force)",
      },
    },
  },
  {
    "echasnovski/mini.move",
    event = "VeryLazy",
    config = true,
  },
  {
    "echasnovski/mini.bracketed",
  },
  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    dependencies = "nvim-treesitter/nvim-treesitter-textobjects",
    opts = function()
      local miniai = require("mini.ai")
      return {
        n_lines = 300,
        custom_textobjects = {
          f = miniai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
        },
        -- Disable error feedback.
        silent = true,
        -- Don't use the previous or next text object.
        search_method = "cover",
        mappings = {
          -- Disable next/last variants.
          around_next = "",
          inside_next = "",
          around_last = "",
          inside_last = "",
        },
      }
    end,
  },
  {
    "echasnovski/mini.hipatterns",
    event = "BufReadPost",
    opts = function()
      local highlighters = {}
      for _, word in ipairs({ "todo", "note", "hack" }) do
        highlighters[word] = {
          pattern = string.format("%%f[%%w]()%s()%%f[%%W]", word:upper()),
          group = string.format("MiniHipatterns%s", word:sub(1, 1):upper() .. word:sub(2)),
        }
      end

      return { highlighters = highlighters }
    end,
  },

  {
    "echasnovski/mini.clue",
    event = "VeryLazy",
    opts = function()
      local miniclue = require("mini.clue")
      -- Ignore these
      -- for _, lhs in ipairs { '[%', ']%', 'g%' } do
      --     vim.keymap.del('n', lhs)
      -- end

      return {
        triggers = {
          -- Leader triggers
          { mode = "n", keys = "<Leader>" },
          { mode = "x", keys = "<Leader>" },

          -- Built-in completion
          { mode = "i", keys = "<C-x>" },

          -- `g` key
          { mode = "n", keys = "g" },
          { mode = "x", keys = "g" },

          -- Marks
          { mode = "n", keys = "'" },
          { mode = "n", keys = "`" },
          { mode = "x", keys = "'" },
          { mode = "x", keys = "`" },

          -- Registers
          { mode = "n", keys = '"' },
          { mode = "x", keys = '"' },
          { mode = "i", keys = "<C-r>" },
          { mode = "c", keys = "<C-r>" },

          -- Window commands
          { mode = "n", keys = "<C-w>" },

          -- `z` key
          { mode = "n", keys = "z" },
          { mode = "x", keys = "z" },
          { mode = "n", keys = "[" },
          { mode = "n", keys = "]" },
        },
        clues = {
          -- Leader/movement groups.
          { mode = "n", keys = "<leader>b", desc = "+buffers" },
          { mode = "n", keys = "<leader>c", desc = "+code" },
          { mode = "x", keys = "<leader>c", desc = "+code" },
          { mode = "n", keys = "<leader>d", desc = "+debug" },
          { mode = "n", keys = "<leader>f", desc = "+find" },
          { mode = "x", keys = "<leader>f", desc = "+find" },
          { mode = "n", keys = "<leader>g", desc = "+git" },
          { mode = "n", keys = "<leader>h", desc = "+hunk" },
          { mode = "n", keys = "<leader>o", desc = "+overseer" },
          { mode = "n", keys = "<leader>x", desc = "+loclist/quickfix" },
          { mode = "n", keys = "[", desc = "+prev" },
          { mode = "n", keys = "]", desc = "+next" },
          miniclue.gen_clues.builtin_completion(),
          miniclue.gen_clues.g(),
          miniclue.gen_clues.marks(),
          miniclue.gen_clues.registers(),
          miniclue.gen_clues.windows(),
          miniclue.gen_clues.z(),
        },
        window = {
          delay = 500,
          config = function(bufnr)
            local max_width = 0
            for _, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)) do
              max_width = math.max(max_width, vim.fn.strchars(line))
            end

            -- Keep some right padding.
            max_width = max_width + 2

            return {
              border = "rounded",
              -- Dynamic width capped at 45.
              width = math.min(45, max_width),
            }
          end,
        },
      }
    end,
  },
}
