Config.now_if_args(function()
  vim.pack.add({
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects", version = "main" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter-context" },
  }, { load = true })

  local ts_update = function()
    vim.cmd("TSUpdate")
  end
  Config.on_packchanged("tree-sitter", { "update" }, ts_update, "Update tree-sitter parsers")

  local ensure_languages = {
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
    -- "prr",
    "python",
    "query",
    "regex",
    "rust",
    "toml",
    "tsx",
    "typescript",
    "vim",
    "yaml",
  }
  require("nvim-treesitter").install(ensure_languages)

  local filetypes = vim.iter(ensure_languages):map(vim.treesitter.language.get_filetypes):flatten():totable()

  Config.new_autocmd("FileType", {
    pattern = filetypes,
    callback = function(ev)
      vim.treesitter.start(ev.buf)
    end,
  })

  Config.new_autocmd("FileType", {
    pattern = filetypes,
    desc = "Enable Treesitter folding",
    callback = function(args)
      local bufnr = args.buf

      -- Enable Treesitter folding when not in huge files and when Treesitter
      -- is working.
      if vim.bo[bufnr].filetype ~= "bigfile" and pcall(vim.treesitter.start, bufnr) then
        vim.api.nvim_buf_call(bufnr, function()
          vim.wo[0][0].foldmethod = "expr"
          vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
          vim.cmd.normal("zx")
        end)
      else
        -- Else just fallback to using indentation.
        vim.wo[0][0].foldmethod = "indent"
      end
    end,
  })

  require("treesitter-context").setup({
    -- Avoid the sticky context from growing a lot.
    max_lines = 3,
    -- Match the context lines to the source code.
    multiline_threshold = 1,
    -- Disable it when the window is too small.
    min_window_height = 20,
  })
end)
