local function config(_, opts)
  local colorscheme = vim.g.colors_name
  local theme
  if colorscheme == "github" then
    local spec = require("github-theme.spec").load(colorscheme)
    local palette = spec.palette
    theme = {
      normal = {
        a = { fg = spec.bg0, bg = palette.blue.bright },
        b = { fg = spec.bg0, bg = spec.fg1 },
        c = { fg = spec.fg1, bg = spec.bg0 },
      },
      insert = { a = { fg = spec.bg0, bg = palette.green.base } },
      visual = { a = { fg = spec.bg0, bg = palette.magenta.base } },
      replace = { a = { fg = spec.bg0, bg = palette.red.base } },
      command = { a = { fg = spec.bg0, bg = palette.orange.base } },
      inactive = {
        a = { fg = spec.fg1, bg = spec.bg0 },
        b = { fg = spec.fg1, bg = spec.bg0 },
        c = { fg = spec.fg1, bg = spec.bg0 },
      },
    }
  else
    local configuration = vim.fn["gruvbox_material#get_configuration"]()
    local palette = vim.fn["gruvbox_material#get_palette"](
      configuration.background,
      configuration.foreground,
      configuration.colors_override
    )

    if configuration.transparent_background == 2 then
      palette.bg_statusline1 = palette.none
      palette.bg_statusline2 = palette.none
    end
    theme = {
      normal = {
        a = { fg = palette.bg0[1], bg = palette.blue[1] },
        b = { fg = palette.bg0[1], bg = palette.fg1[1] },
        c = { fg = palette.fg1[1], bg = palette.bg0[1] },
      },
      insert = { a = { fg = palette.bg0[1], bg = palette.green[1] } },
      visual = { a = { fg = palette.bg0[1], bg = palette.purple[1] } },
      replace = { a = { fg = palette.bg0[1], bg = palette.red[1] } },
      command = { a = { fg = palette.bg0[1], bg = palette.orange[1] } },
      inactive = {
        a = { fg = palette.fg1[1], bg = palette.bg0[1] },
        b = { fg = palette.fg1[1], bg = palette.bg0[1] },
        c = { fg = palette.fg1[1], bg = palette.bg0[1] },
      },
    }
  end

  local lualine = require("lualine")

  local components = {
    sections = {
      lualine_a = {
        { "mode", separator = { left = "", right = "" } },
      },
      lualine_b = {
        { "branch", icon = "", separator = { left = "", right = "" } },
      },
      lualine_c = {
        {
          "diagnostics",
          symbols = {
            error = _G.ui.icons.diagnostics.error,
            warn = _G.ui.icons.diagnostics.warn,
            info = _G.ui.icons.diagnostics.info,
            hint = _G.ui.icons.diagnostics.hint,
          },
        },
        { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
        { "filename", separator = { left = "", right = "" } },
      },
      lualine_x = {
        Snacks.profiler.status(),
        {
          function()
            return "  " .. require("dap").status()
          end,
          cond = function()
            return package.loaded["dap"] and require("dap").status() ~= ""
          end,
          color = function()
            return { fg = Snacks.util.color("Debug") }
          end,
        },
      },
      lualine_y = {
        { "progress", separator = " ", padding = { left = 1, right = 0 } },
        { "location", padding = { left = 0, right = 1 } },
      },
      lualine_z = {
        function()
          return " " .. os.date("%R")
        end,
      },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {
        { "filename", separator = { left = "", right = "" } },
      },
      lualine_x = {},
      lualine_y = {},
      lualine_z = {},
    },
  }

  opts.sections = components.sections
  opts.inactive_sections = components.inactive_sections
  -- opts.options = { theme = theme }
  opts.options = {
    theme = "gruvbox",
  }
  opts.extensions = { "fzf", "lazy", "nvim-dap-ui", "aerial", "trouble" }

  lualine.setup(opts)
end

return {
  "nvim-lualine/lualine.nvim",
  config = config,
  event = { "UIEnter" },
  opts = {},
}
