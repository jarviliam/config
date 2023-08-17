--require("nvim-treesitter.install").compilers = {"clang++"}
-- require("nvim-treesitter.install").compilers = { "gcc", "clang", "cl" }
require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "bash",
    "c",
    "cpp",
    "cmake",
    "dockerfile",
    "json5",
    "norg",
    "c_sharp",
    "comment",
    "dhall",
    "go",
    "html",
    "javascript",
    "json",
    "lua",
    "luadoc",
    "luap",
    "markdown",
    "markdown_inline",
    "nix",
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
  ignore_install = { "phpdoc", "haskell_persistent" },
  auto_install = true,
  highlight = {
    enable = true,
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
    highlight_definitions = { enable = true },
  },
})
vim.treesitter.language.register('markdown', 'octo')
require 'treesitter-context'.setup {
  enable = true,            -- Enable this plugin (Can be enabled/disabled later via commands)
  max_lines = 0,            -- How many lines the window should span. Values <= 0 mean no limit.
  min_window_height = 0,    -- Minimum editor window height to enable context. Values <= 0 mean no limit.
  line_numbers = true,
  multiline_threshold = 20, -- Maximum number of lines to collapse for a single context line
  trim_scope = 'outer',     -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
  mode = 'cursor',          -- Line used to calculate context. Choices: 'cursor', 'topline'
  -- Separator between context and content. Should be a single character string, like '-'.
  -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
  separator = nil,
  zindex = 20,     -- The Z-index of the context window
  on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
}
