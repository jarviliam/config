local map_split = function(buf_id, lhs, direction)
  local minifiles = require("mini.files")

  local rhs = function()
    local window = minifiles.get_explorer_state().target_window

    -- Noop if the explorer isn't open or the cursor is on a directory.
    if window == nil or minifiles.get_fs_entry().fs_type == "directory" then
      return
    end
    -- Make new window and set it as target
    local new_target_window
    vim.api.nvim_win_call(minifiles.get_target_window() or 0, function()
      vim.cmd(direction .. " split")
      new_target_window = vim.api.nvim_get_current_win()
    end)
    minifiles.set_target_window(new_target_window)
    -- Go in and close the explorer.
    minifiles.go_in({ close_on_file = true })
  end
  local desc = "Split " .. string.sub(direction, 12)
  vim.keymap.set("n", lhs, rhs, { buffer = buf_id, desc = desc })
end

return {
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
    },
  },
  {
    "echasnovski/mini.move",
    event = "VeryLazy",
    config = true,
  },
  {
    "echasnovski/mini.bracketed",
    enable = false,
    config = function()
      require("mini.bracketed").setup({})
    end,
  },
  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
    opts = function()
      local ai = require("mini.ai")
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({ -- code block
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }), -- class
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tags
          d = { "%f[%d]%d+" }, -- digits
          e = { -- Word with case
            { "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
            "^().*()$",
          },
          u = ai.gen_spec.function_call(), -- u for "Usage"
          U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
        },
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
    "echasnovski/mini.files",
    keys = {
      {
        "<leader>e",
        function()
          local bufname = vim.api.nvim_buf_get_name(0)
          local path = vim.fn.fnamemodify(bufname, ":p")
          if path and vim.uv.fs_stat(path) then
            require("mini.files").open(bufname, false)
          end
        end,
        desc = "File explorer",
      },
    },
    opts = {
      mappings = {
        show_help = "?",
        go_in_plus = "<cr>",
        go_out_plus = "<tab>",
      },
      content = {
        filter = function(entry)
          return entry.fs_type ~= "file" or entry.name ~= ".DS_Store"
        end,
        windows = { width_nofocus = 25 },
        options = { permanent_delete = false },
      },
    },
    config = function(_, opts)
      local minifiles = require("mini.files")
      minifiles.setup(opts)
      vim.api.nvim_create_autocmd("User", {
        desc = "Add rounded corners",
        pattern = "MiniFilesWindowOpen",
        callback = function(args)
          vim.api.nvim_win_set_config(args.data.win_id, { border = "rounded" })
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        desc = "Add minifiles split keymaps",
        pattern = "MiniFilesBufferCreate",
        callback = function(args)
          local buffer = args.data.buf_id
          map_split(buffer, "<C-s>", "belowright horizontal")
          map_split(buffer, "<C-v>", "belowright vertical")
        end,
      })
    end,
  },

  {
    "echasnovski/mini.clue",
    enable = false,
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
          { mode = "n", keys = "<leader>h", desc = "+hunk" },
          { mode = "n", keys = "<leader>o", desc = "+overseer" },
          { mode = "n", keys = "<leader>T", desc = "+tabs" },
          { mode = "n", keys = "<leader>t", desc = "+tests" },
          { mode = "n", keys = "<leader>u", desc = "+ui" },
          { mode = "n", keys = "<leader>x", desc = "+loclist/quickfix" },
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
    config = true,
  },
}
