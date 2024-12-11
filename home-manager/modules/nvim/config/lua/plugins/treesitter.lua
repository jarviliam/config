return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = "VeryLazy",
    build = function()
      local install = require("nvim-treesitter.install")
      install.compilers = { "gcc", "clang", "cl" }
      install.update({ with_sync = true })()
    end,
    priority = 80,
    keys = { { "<leader>i", vim.show_pos, desc = "Inspect Position" } },
    init = function(plugin)
      require("lazy.core.loader").add_to_rtp(plugin)
      require("nvim-treesitter.query_predicates")
    end,
    opts = {
      auto_install = true,
      ensure_installed = {
        "bash",
        "c",
        "cpp",
        "cmake",
        "dockerfile",
        "json5",
        "norg",
        "comment",
        "go",
        "graphql",
        "gomod",
        "gowork",
        "gosum",
        "gitcommit",
        "git_config",
        "gitignore",
        "html",
        "javascript",
        "json",
        "lua",
        "luadoc",
        "markdown",
        "markdown_inline",
        "nix",
        "po",
        "python",
        "query",
        "regex",
        "rust",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "yaml",
      },
      fold = {
        enable = true,
      },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { "markdown" },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          ["]m"] = "@function.outer",
          ["]P"] = "@parameter.outer",
        },
        goto_next_end = {
          ["]m"] = "@function.outer",
          ["]P"] = "@parameter.outer",
        },
        goto_previous_start = {
          ["[m"] = "@function.outer",
          ["[P"] = "@parameter.outer",
        },
        goto_previous_end = {
          ["[m"] = "@function.outer",
          ["[P"] = "@parameter.outer",
        },
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
      indent = { enable = true },
      autopairs = { enable = true },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
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
    "nvim-treesitter/nvim-treesitter-context",
    opts = {
      -- Avoid the sticky context from growing a lot.
      max_lines = 3,
      -- Match the context lines to the source code.
      multiline_threshold = 1,
      -- Disable it when the window is too small.
      min_window_height = 20,
    },
    keys = {
      {
        "[c",
        function()
          -- Jump to previous change when in diffview.
          if vim.wo.diff then
            return "[c"
          else
            vim.schedule(function()
              require("treesitter-context").go_to_context()
            end)
            return "<Ignore>"
          end
        end,
        desc = "Jump to upper context",
        expr = true,
      },
    },
  },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
  },
}
