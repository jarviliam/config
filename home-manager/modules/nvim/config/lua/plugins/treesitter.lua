return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    { "nvim-treesitter/playground" },
    "nvim-treesitter/nvim-treesitter-refactor",
    "nvim-treesitter/nvim-treesitter-textobjects",
    "nvim-treesitter/nvim-treesitter-context",
  },
  event = { "BufReadPre", "BufNewFile" },
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
    },
    indent = { enable = true },
    autopairs = { enable = true },
    textobjects = {
      select = {
        enable = true,
        keymaps = {
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ao"] = "@class.outer",
          ["io"] = "@class.inner",
          ["ac"] = "@conditional.outer",
          ["ic"] = "@conditional.inner",
          ["ae"] = "@block.outer",
          ["ie"] = "@block.inner",
          ["al"] = "@loop.outer",
          ["il"] = "@loop.inner",
          ["is"] = "@statement.inner",
          ["as"] = "@statement.outer",
          ["ad"] = "@comment.outer",
          ["id"] = "@comment.inner",
          ["am"] = "@call.outer",
          ["im"] = "@call.inner",
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          ["]f"] = "@function.outer",
          ["]]"] = "@class.outer",
        },
        goto_next_end = {
          ["]F"] = "@function.outer",
          ["]["] = "@class.outer",
        },
        goto_previous_start = {
          ["[f"] = "@function.outer",
          ["[["] = "@class.outer",
        },
        goto_previous_end = {
          ["[F"] = "@function.outer",
          ["[]"] = "@class.outer",
        },
      },
    },
    playground = {
      enable = true,
      updatetime = 25,
      persist_queries = false,
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
}
