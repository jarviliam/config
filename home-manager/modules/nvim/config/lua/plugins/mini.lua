return {
  {
    "echasnovski/mini.move",
    event = "VeryLazy",
    config = true,
  },
  {
    "echasnovski/mini.hipatterns",
    event = "BufReadPost",
    enable = false,
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
    "echasnovski/mini.ai",
    event = "VeryLazy",
    config = function(_, _)
      local ai = require("mini.ai")
      require("mini.ai").setup({
        n_lines = 2000,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({ -- code block
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }), -- class
          d = { "%f[%d]%d+" }, -- digits
          e = { -- Word with case
            { "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
            "^().*()$",
          },
          u = ai.gen_spec.function_call(), -- u for "Usage"
          U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
        },
      })
    end,
  },

  {
    "echasnovski/mini.clue",
    enable = true,
    event = "VeryLazy",
    opts = function()
      local miniclue = require("mini.clue")
      return {
        triggers = {
          -- Leader triggers
          { mode = "n", keys = "<Leader>" },
          { mode = "x", keys = "<Leader>" },
          { mode = "n", keys = [[\]] }, -- mini.basics

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

          { mode = "n", keys = "[" }, -- mini.bracketed
          { mode = "n", keys = "]" },
          { mode = "x", keys = "[" },
          { mode = "x", keys = "]" },
        },
        clues = {
          -- Leader/movement groups.
          { mode = "n", keys = "<leader>a", desc = "+ai" },
          { mode = "v", keys = "<leader>a", desc = "+ai" },
          { mode = "n", keys = "<leader>b", desc = "+buffers" },
          { mode = "n", keys = "<leader>c", desc = "+code" },
          { mode = "x", keys = "<leader>c", desc = "+code" },
          { mode = "n", keys = "<leader>d", desc = "+debug" },
          { mode = "n", keys = "<leader>f", desc = "+find" },
          { mode = "x", keys = "<leader>f", desc = "+find" },
          { mode = "n", keys = "<leader>g", desc = "+git" },
          { mode = "n", keys = "gc", desc = "+comment" },
          { mode = "n", keys = "<leader>gd", desc = "+diff" },
          { mode = "n", keys = "<leader>o", desc = "+overseer" },
          { mode = "n", keys = "<leader>r", desc = "+rules" },
          { mode = "n", keys = "<leader>s", desc = "+search" },
          { mode = "n", keys = "<leader>S", desc = "+session" },
          { mode = "n", keys = "<leader>T", desc = "+tabs" },
          { mode = "n", keys = "<leader>t", desc = "+tests" },
          { mode = "n", keys = "\\", desc = "+toggle" },
          { mode = "n", keys = "<leader>u", desc = "+ui" },
          { mode = "n", keys = "<leader>x", desc = "+loclist/quickfix" },
          { mode = "n", keys = "<leader>z", desc = "+fold" },
          miniclue.gen_clues.builtin_completion(),
          miniclue.gen_clues.g(),
          miniclue.gen_clues.marks(),
          miniclue.gen_clues.registers(),
          miniclue.gen_clues.windows(),
          miniclue.gen_clues.z(),
        },
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
              border = "rounded",
              -- Dynamic width capped at 45.
              width = math.min(45, max_width),
            }
          end,
        },
      }
    end,
  },
  {
    "echasnovski/mini.pairs",
    event = "InsertEnter",
    config = function(_, opts)
      local pairs = require("mini.pairs")
      require("snacks").toggle
        .new({
          name = "Mini Pairs",
          get = function()
            return not vim.g.minipairs_disable
          end,
          set = function(state)
            vim.g.minipairs_disable = not state
          end,
        })
        :map("\\p")

      pairs.setup(opts)
    end,
  },
}
