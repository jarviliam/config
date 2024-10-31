-- configure feline
local function config(_, opts)
  local colorscheme = vim.g.colors_name
  local theme
  local palette
  if colorscheme == "github" then
    local spec = require("github-theme.spec").load(colorscheme)
    palette = spec.palette
    -- theme = {
    --   fg = spec.fg1,
    --   bg = spec.bg0,
    --   black = palette.black.base,
    --   skyblue = palette.blue.bright,
    --   cyan = palette.cyan.base,
    --   green = palette.green.base,
    --   oceanblue = palette.blue.base,
    --   magenta = palette.magenta.base,
    --   orange = palette.orange.base,
    --   red = palette.red.base,
    --   violet = palette.magenta.bright,
    --   white = palette.white.base,
    --   yellow = palette.yellow.base,
    -- }
  else
    local configuration = vim.fn["gruvbox_material#get_configuration"]()
    palette = vim.fn["gruvbox_material#get_palette"](
      configuration.background,
      configuration.foreground,
      configuration.colors_override
    )

    if configuration.transparent_background == 2 then
      palette.bg_statusline1 = palette.none
      palette.bg_statusline2 = palette.none
    end
    -- theme = {
    --   fg = palette.fg1[1],
    --   bg = palette.bg0[1],
    --   black = palette.bg0[1],
    --   skyblue = palette.blue[1],
    --   cyan = palette.aqua[1],
    --   green = palette.green[1],
    --   oceanblue = palette.blue[1],
    --   magenta = palette.purple[1],
    --   orange = palette.orange[1],
    --   red = palette.red[1],
    --   violet = palette.purple[1],
    --   white = palette.fg1[1],
    --   yellow = palette.yellow[1],
    -- }
  end

  local feline = require("feline")
  local vi_mode = require("feline.providers.vi_mode")
  local file = require("feline.providers.file")
  local separators = require("feline.defaults").statusline.separators.default_value
  local lsp = require("feline.providers.lsp")

  local c = {
    -- left
    vim_status = {
      provider = function()
        return "  "
      end,
      hl = { fg = palette.bg0[1], bg = palette.blue[1] },
      right_sep = {
        always_visible = true,
        str = separators.slant_right,
        hl = { fg = palette.blue[1], bg = palette.bg0[1] },
      },
    },

    file_name = {
      provider = {
        name = "file_info",
        opts = { colored_icon = false },
      },
      hl = { fg = palette.bg0[1], bg = palette.fg1[1] },
      left_sep = {
        always_visible = true,
        str = string.format("%s ", separators.slant_right),
        hl = { fg = palette.bg0[1], bg = palette.fg1[1] },
      },
    },

    git_branch = {
      provider = function()
        local git = require("feline.providers.git")
        local branch, icon = git.git_branch()
        local s
        if #branch > 0 then
          s = string.format(" %s%s ", icon, branch)
        else
          s = string.format(" %s ", "Untracked")
        end
        return s
      end,
      hl = { fg = palette.bg0[1], bg = palette.fg3[1] },
      left_sep = {
        always_visible = true,
        str = string.format("%s%s", separators.block, separators.slant_right),
        hl = { fg = palette.fg1[1], bg = palette.fg3[1] },
      },
      right_sep = {
        always_visible = true,
        str = separators.slant_right,
        hl = { fg = palette.fg3[1], bg = palette.bg0[1] },
      },
    },

    lsp = {
      provider = function()
        if not lsp.is_lsp_attached() then
          return " 󱏎 LSP "
        end
        return ""
      end,
      hl = function()
        if not lsp.is_lsp_attached() then
          return { fg = palette.bg0[1], bg = palette.fg3[1] }
        end
        return { fg = palette.bg0[1], bg = palette.green[1] }
      end,
      left_sep = {
        always_visible = true,
        str = separators.slant_right,
        hl = function()
          if not lsp.is_lsp_attached() then
            return { fg = palette.bg0[1], bg = palette.fg3[1] }
          end
          return { fg = palette.bg0[1], bg = palette.green[1] }
        end,
      },
      right_sep = {
        always_visible = true,
        str = separators.slant_right,
        hl = function()
          if not lsp.is_lsp_attached() then
            return { fg = palette.fg3[1], bg = "none" }
          end
          return { fg = palette.green[1], bg = "none" }
        end,
      },
    },

    -- right
    vi_mode = {
      provider = function()
        return string.format(" %s ", vi_mode.get_vim_mode())
      end,
      hl = function()
        return { fg = palette.bg0[1], bg = vi_mode.get_mode_color() }
      end,
      left_sep = {
        always_visible = true,
        str = separators.slant_left,
        hl = function()
          return { fg = vi_mode.get_mode_color(), bg = "none" }
        end,
      },
      right_sep = {
        always_visible = true,
        str = separators.slant_left,
        hl = function()
          return { fg = palette.bg0[1], bg = vi_mode.get_mode_color() }
        end,
      },
    },

    macro = {
      provider = function()
        local s
        local recording_register = vim.fn.reg_recording()
        if #recording_register == 0 then
          s = ""
        else
          s = string.format(" Recording @%s ", recording_register)
        end
        return s
      end,
      hl = { fg = palette.bg0[1], bg = palette.fg3[1] },
      left_sep = {
        always_visible = true,
        str = separators.slant_left,
        hl = function()
          return { fg = palette.fg3[1], bg = palette.bg0[1] }
        end,
      },
    },

    search_count = {
      provider = function()
        if vim.v.hlsearch == 0 then
          return ""
        end

        local ok, result = pcall(vim.fn.searchcount, { maxcount = 999, timeout = 250 })
        if not ok then
          return ""
        end
        if next(result) == nil then
          return ""
        end

        local denominator = math.min(result.total, result.maxcount)
        return string.format(" [%d/%d] ", result.current, denominator)
      end,
      hl = { fg = palette.bg0[1], bg = palette.fg1[1] },
      left_sep = {
        always_visible = true,
        str = separators.slant_left,
        hl = function()
          return { fg = palette.fg1[1], bg = palette.fg3[1] }
        end,
      },
      right_sep = {
        always_visible = true,
        str = separators.slant_left,
        hl = { fg = palette.bg0[1], bg = palette.fg1[1] },
      },
    },

    cursor_position = {
      provider = {
        name = "position",
        opts = { padding = true },
      },
      hl = { fg = palette.bg0[1], bg = palette.blue[1] },
      left_sep = {
        always_visible = true,
        str = string.format("%s%s", separators.slant_left, separators.block),
        hl = function()
          return { fg = palette.blue[1], bg = palette.bg0[1] }
        end,
      },
      right_sep = {
        always_visible = true,
        str = " ",
        hl = { fg = palette.bg0[1], bg = palette.blue[1] },
      },
    },

    scroll_bar = {
      provider = {
        name = "scroll_bar",
        opts = { reverse = true },
      },
      hl = { fg = palette.blue[1], bg = palette.blue[1] },
    },

    -- inactive statusline
    in_file_info = {
      provider = function()
        if vim.api.nvim_buf_get_name(0) ~= "" then
          return file.file_info({}, { colored_icon = false })
        else
          return file.file_type({}, { colored_icon = false, case = "lowercase" })
        end
      end,
      hl = { fg = palette.bg0[1], bg = palette.blue[1] },
      left_sep = {
        always_visible = true,
        str = string.format("%s%s", separators.slant_left, separators.block),
        hl = { fg = palette.blue[1], bg = "none" },
      },
      right_sep = {
        always_visible = true,
        str = " ",
        hl = { fg = palette.bg0[1], bg = palette.blue[1] },
      },
    },
  }

  local active = {
    { -- left
      c.vim_status,
      c.file_name,
      c.git_branch,
      c.lsp,
    },
    { -- right
      c.vi_mode,
      c.macro,
      c.search_count,
      c.cursor_position,
      c.scroll_bar,
    },
  }

  local inactive = {
    { -- left
    },
    { -- right
      c.in_file_info,
    },
  }

  opts.components = { active = active, inactive = inactive }

  feline.setup(opts)
  feline.use_theme(theme)
end

return {
  "freddiehaddad/feline.nvim",
  config = config,
  event = { "UIEnter" },
  dependencies = {
    "kyazdani42/nvim-web-devicons",
    "lewis6991/gitsigns.nvim",
  },
  opts = {},
}
