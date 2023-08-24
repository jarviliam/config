return {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      { "nvim-treesitter/playground"},
      "nvim-treesitter/nvim-treesitter-refactor",
      "nvim-treesitter/nvim-treesitter-textobjects",
      "nvim-treesitter/nvim-treesitter-context",
      "RRethy/nvim-treesitter-textsubjects",
    },
    event = "User FileOpened",
    build = function()
        local install = require("nvim-treesitter.install")
        install.compilers = { "gcc", "clang", "cl" }
        install.update({ with_sync = true })()
    end,
    opts = function ()
    require("nvim-treesitter.configs").setup({
      auto_install = true,
      ignore_install = {},
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
      highlight = {
        enable = true,
        disable = function(_lang, buffer)
              return vim.api.nvim_buf_line_count(buffer) > 50000
            end
      },
      indent = { enable = true },
      autopairs = { enable = true },
      textsubjects = {
        enable = true,
        keymaps = {
          ["<CR>"] = "textsubjects-smart",
          [";"] = "textsubjects-container-outer",
        },
      },
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
        lsp_interop = {
          enable = true,
          peek_definition_code = {
            ["<leader>np"] = "@function.outer",
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ["<leader>a"] = "@parameter.inner",
            ["<leader>f"] = "@function.outer",
            ["<leader>e"] = "@element",
          },
          swap_previous = {
            ["<leader>A"] = "@parameter.inner",
            ["<leader>F"] = "@function.outer",
            ["<leader>E"] = "@element",
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
              enable               = true,
              disable = function(lang, buffer)
                local skip = { "help" }

                return vim.api.nvim_buf_line_count(buffer) > 20000 or vim.tbl_contains(skip, lang)
              end,
              clear_on_cursor_move = true,
            },
      },
    })
    end
}
