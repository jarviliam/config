return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-refactor",
      "nvim-treesitter/nvim-treesitter-textobjects",
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
    },
    keys = {
      { "<c-space>", desc = "Increment selection" },
      { "<bs>", desc = "Decrement selection", mode = "x" },
    },
    event = { "VeryLazy" },
    build = function()
      local install = require("nvim-treesitter.install")
      install.compilers = { "gcc", "clang", "cl" }
      install.update({ with_sync = true })()
    end,
    priority = 80,
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
        disable = function(_, buffer)
          return vim.api.nvim_buf_line_count(buffer) > 50000
        end,
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
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["ak"] = { query = "@block.outer", desc = "around block" },
            ["ik"] = { query = "@block.inner", desc = "inside block" },
            ["ac"] = { query = "@class.outer", desc = "around class" },
            ["ic"] = { query = "@class.inner", desc = "inside class" },
            ["a?"] = { query = "@conditional.outer", desc = "around conditional" },
            ["i?"] = { query = "@conditional.inner", desc = "inside conditional" },
            ["af"] = { query = "@function.outer", desc = "around function " },
            ["if"] = { query = "@function.inner", desc = "inside function " },
            ["al"] = { query = "@loop.outer", desc = "around loop" },
            ["il"] = { query = "@loop.inner", desc = "inside loop" },
            ["aa"] = { query = "@parameter.outer", desc = "around argument" },
            ["ia"] = { query = "@parameter.inner", desc = "inside argument" },
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
          goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
          goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
          goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
        },
      },
      refactor = {
        highlight_definitions = {
          enable = true,
          disable = function(lang, buffer)
            return vim.api.nvim_buf_line_count(buffer) > 10 * 1024 or vim.tbl_contains({ "help" }, lang)
          end,
          clear_on_cursor_move = true,
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
  },
}
