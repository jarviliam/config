---@type LazySpec[]
return {
  { "nvim-mini/mini.nvim" },
  {
    "nvim-mini/mini.git",
    virtual = true,
    lazy = false,
  },
  {
    "nvim-mini/mini.statusline",
    virtual = true,
    lazy = false,
  },
  {
    "nvim-mini/mini.diff",
    virtual = true,
    lazy = false,
    keys = {
      {
        "\\g",
        function()
          require("mini.diff").toggle_overlay(0)
        end,
        mode = { "n" },
        desc = "Toggle Diff Overlay",
      },
    },
    config = function()
      require("mini.diff").setup({})
    end,
  },
  {
    "nvim-mini/mini.surround",
    virtual = true,
    opts = {
      mappings = {
        add = "yz", -- Add surrounding in Normal and Visual modes
        delete = "ds", -- Delete surrounding
        find = "", -- Find surrounding (to the right)
        find_left = "", -- Find surrounding (to the left)
        highlight = "", -- Highlight surrounding
        replace = "cs", -- Replace surrounding

        suffix_last = "", -- Suffix to search with "prev" method
        suffix_next = "", -- Suffix to search with "next" method
      },
    },
    lazy = false,
  },
  {
    "nvim-mini/mini.hipatterns",
    event = "BufReadPost",
    virtual = true,
  },
  {
    "nvim-mini/mini.splitjoin",
    virtual = true,
    keys = {
      {
        "<leader>cj",
        function()
          require("mini.splitjoin").toggle()
        end,
        desc = "Join/split code block",
      },
    },
    opts = {
      mappings = {
        toggle = "<leader>cj",
      },
    },
  },
  {
    "nvim-mini/mini.files",
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
    virtual = true,
  },
  {
    "nvim-mini/mini.ai",
    event = "LazyFile",
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
    virtual = true,
  },
  {
    "nvim-mini/mini.clue",
    event = "VeryLazy",
    virtual = true,
  },
  {
    "nvim-mini/mini.icons",
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
    lazy = false,
    opts = {
      glyph = true,
    },
    virtual = true,
  },
  {
    "nvim-mini/mini.pairs",
    event = "InsertEnter",
    config = function(_, opts)
      local pairs = require("mini.pairs")
      pairs.setup(opts)
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
    end,
    virtual = true,
  },
  {
    "nvim-mini/mini.align",
    keys = {
      { "g=", desc = "mini.align: align", mode = { "n", "v" } },
      { "g+", desc = "mini.align: align with preview", mode = { "n", "" } },
    },
    opts = {
      mappings = {
        start = "g=",
        start_with_preview = "g+",
      },
    },
    virtual = true,
  },
  {
    {
      "nvim-mini/mini.bracketed",
      keys = {
        { "[c", desc = "comment previous " },
        { "]c", desc = "comment next" },
        { "[w", desc = "window previous" },
        { "]w", desc = "window next" },
        { "[x", desc = "conflict marker previous" },
        { "]x", desc = "conflict marker next" },
      },
      opts = {
        buffer = { suffix = "" },
        file = { suffix = "" },
        diagnostic = { suffix = "" }, -- Built in.
        indent = { suffix = "" },
        jump = { suffix = "" },
        location = { suffix = "" },
        oldfile = { suffix = "" },
        quickfix = { suffix = "" },
        treesitter = { suffix = "" },
        undo = { suffix = "" },
        yank = { suffix = "" },
      },
      virtual = true,
    },
  },
}
