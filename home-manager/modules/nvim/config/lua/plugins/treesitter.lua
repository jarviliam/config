return {
  {
    ---@module "nvim-treesitter"
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    branch = "main",
    keys = { { "<leader>i", vim.show_pos, desc = "Inspect Position" } },
    build = ":TSUpdate",
    priority = 500,
    opts = {
      sync_install = true,
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
      ignore_install = { "unsupported" },
      textobjects = {
        swap = {
          enable = true,
          swap_next = {
            ["<leader>ca"] = "@parameter.inner",
          },
          swap_previous = {
            ["<leader>cA"] = "@parameter.inner",
          },
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
      },
      fold = {
        enable = true,
      },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { "markdown" },
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
