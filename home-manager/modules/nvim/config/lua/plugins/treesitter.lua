return {
  {
    "nvim-treesitter/nvim-treesitter",
    init = function(plugin)
      -- vim.g.loaded_nvim_treesitter = 1
      require("lazy.core.loader").add_to_rtp(plugin)
      -- require("nvim-treesitter.query_predicates")
    end,
    lazy = false,
    keys = { { "<leader>i", vim.show_pos, desc = "Inspect Position" } },
    opts = {
      ensure_install = {},
      ignore_install = { "unsupported" },
      -- install_dir = vim.g.ts_path,
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
  },
  {
    "lewis6991/ts-install.nvim",
    event = "VeryLazy",
    build = ":TS update!",
    opts = {
      auto_install = false,
      install_dir = vim.g.ts_path,
      ensure_install = {
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
    },
  },
  { "nvim-treesitter/nvim-treesitter-textobjects", branch = "main", event = "VeryLazy" },
  {
    "folke/ts-comments.nvim",
    event = "VeryLazy",
    opts = {},
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
}
