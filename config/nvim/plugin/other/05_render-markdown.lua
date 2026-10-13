Config.now_if_args(function()
  vim.pack.add({ "https://github.com/MeanderingProgrammer/render-markdown.nvim" }, { load = true })

  local md = require("render-markdown")
  md.setup({
    file_types = { "markdown", "vimwiki", "codecompanion" },
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
  })
end)
