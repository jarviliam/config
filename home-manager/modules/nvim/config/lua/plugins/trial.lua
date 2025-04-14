return {
  { "tpope/vim-sleuth", event = "BufReadPre" },
  {
    "j-hui/fidget.nvim",
    opts = {
      -- options
    },
  },
  {
    "fredrikaverpil/godoc.nvim",
    dev = false,
    version = "*",
    build = "go install github.com/lotusirous/gostdsym/stdsym@latest", -- optional
    cmd = { "GoDoc" },
    opts = {},
  },
  {
    "folke/trouble.nvim",
    cmd = { "Trouble" },
    keys = {
            -- stylua: ignore
            { "<leader>xx", function() require("trouble").toggle({ mode = "diagnostics" }) end, desc = "Trouble" },
    },
    opts = {
      auto_preview = false,
      focus = true,
      modes = {
        lsp_references = {
          params = {
            include_declaration = false,
          },
        },
      },
    },
  },
  {
    "folke/todo-comments.nvim",
    -- stylua: ignore
    keys = {
        { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
        { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
        { "<leader>ft", function () require("todo-comments.fzf").todo() end, desc = "TODOs" },
    },
    event = "VeryLazy",
    lazy = true,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "codecompanion" },
    ---@module "render-markdown"
    ---@type render.md.UserConfig
    opts = {
      checkbox = {
        enabled = false,
      },
      code = {
        border = "none",
        language_pad = 2,
        left_pad = 2,
        min_width = 45,
        right_pad = 2,
        sign = false,
        width = "block",
      },
      completions = {
        lsp = {
          enabled = true,
        },
      },
      heading = {
        position = "inline",
        sign = false,
      },
      on = {
        attach = function()
          Snacks.toggle({
            name = "Markdown",
            get = function()
              return require("render-markdown.state").enabled
            end,
            set = function(enabled)
              local m = require("render-markdown")
              if enabled then
                m.enable()
              else
                m.disable()
              end
            end,
          }):map("\\m")
        end,
      },
      overrides = {
        filetype = {
          codecompanion = {
            enabled = true,
            anti_conceal = {
              enabled = false,
            },
            heading = {
              backgrounds = {},
              icons = { "", "󰭹 ", "󱙺 ", "", "", "" },
            },
            render_modes = true,
          },
        },
      },
      sign = {
        enabled = false, -- Turn off in the status column
      },
    },
  },
}
