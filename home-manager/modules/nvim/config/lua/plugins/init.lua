local conf = require("conf")
local function get_config(name)
  return string.format('require("modules.%s")', name)
end

return {
  "nvim-lua/plenary.nvim",
  {
    "kyazdani42/nvim-web-devicons",
    opts = { default = true },
  },
  { "jose-elias-alvarez/null-ls.nvim", enabled = false },
  {
    "danymat/neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
      local neogen = require("neogen")
      neogen.setup({
        enabled = true,
        input_after_comment = true,
        snippet_engine = "luasnip",
      })

      vim.keymap.set("n", "<leader>og", neogen.generate, { silent = true, desc = "neogen: generate" })
      vim.keymap.set("n", "<leader>of", function()
        neogen.generate({ type = "func" })
      end, { silent = true, desc = "neogen: generate function" })
      vim.keymap.set("n", "<leader>oc", function()
        neogen.generate({ type = "class" })
      end, { silent = true, desc = "neogen: generate class" })
    end,
    version = "*",
  },
  {
    "ibhagwan/fzf-lua",
    dependencies = "kyazdani42/nvim-web-devicons",
    lazy = false,
    config = function()
      require("fzf-lua").setup({ "fzf-native" })
    end,
  },
  {
    "folke/trouble.nvim",
    dependencies = "kyazdani42/nvim-web-devicons",
  },
  {
    "mrjones2014/smart-splits.nvim",
    lazy = false,
    config = function()
      require("smart-splits").setup({
        ignored_filetypes = {
          "nofile",
          "quickfix",
          "prompt",
        },
        ignored_buftypes = { "NvimTree" },
        default_amount = 3,
        -- Desired behavior when your cursor is at an edge and you
        -- are moving towards that same edge:
        -- 'wrap' => Wrap to opposite side
        -- 'split' => Create a new split in the desired direction
        -- 'stop' => Do nothing
        -- function => You handle the behavior yourself
        -- NOTE: If using a function, the function will be called with
        -- a context object with the following fields:
        -- {
        --    mux = {
        --      type:'tmux'|'wezterm'|'kitty'
        --      current_pane_id():number,
        --      is_in_session(): boolean
        --      current_pane_is_zoomed():boolean,
        --      -- following methods return a boolean to indicate success or failure
        --      current_pane_at_edge(direction:'left'|'right'|'up'|'down'):boolean
        --      next_pane(direction:'left'|'right'|'up'|'down'):boolean
        --      resize_pane(direction:'left'|'right'|'up'|'down'):boolean
        --      split_pane(direction:'left'|'right'|'up'|'down',size:number|nil):boolean
        --    },
        --    direction = 'left'|'right'|'up'|'down',
        --    split(), -- utility function to split current Neovim pane in the current direction
        --    wrap(), -- utility function to wrap to opposite Neovim pane
        -- }
        -- NOTE: `at_edge = 'wrap'` is not supported on Kitty terminal
        -- multiplexer, as there is no way to determine layout via the CLI
        at_edge = "wrap",
        -- when moving cursor between splits left or right,
        -- place the cursor on the same row of the *screen*
        -- regardless of line numbers. False by default.
        -- Can be overridden via function parameter, see Usage.
        move_cursor_same_row = false,
        -- whether the cursor should follow the buffer when swapping
        -- buffers by default; it can also be controlled by passing
        -- `{ move_cursor = true }` or `{ move_cursor = false }`
        -- when calling the Lua function.
        cursor_follows_swapped_bufs = false,
        -- resize mode options
        resize_mode = {
          -- key to exit persistent resize mode
          quit_key = "<ESC>",
          -- keys to use for moving in resize mode
          -- in order of left, down, up' right
          resize_keys = { "h", "j", "k", "l" },
          -- set to true to silence the notifications
          -- when entering/exiting persistent resize mode
          silent = false,
          -- must be functions, they will be executed when
          -- entering or exiting the resize mode
          hooks = {
            on_enter = nil,
            on_leave = nil,
          },
        },
        -- ignore these autocmd events (via :h eventignore) while processing
        -- smart-splits.nvim computations, which involve visiting different
        -- buffers and windows. These events will be ignored during processing,
        -- and un-ignored on completed. This only applies to resize events,
        -- not cursor movement events.
        ignored_events = {
          "BufEnter",
          "WinEnter",
        },
        -- enable or disable a multiplexer integration;
        -- automatically determined, unless explicitly disabled or set,
        -- by checking the $TERM_PROGRAM environment variable,
        -- and the $KITTY_LISTEN_ON environment variable for Kitty
        multiplexer_integration = nil,
        -- disable multiplexer navigation if current multiplexer pane is zoomed
        -- this functionality is only supported on tmux and Wezterm due to kitty
        -- not having a way to check if a pane is zoomed
        disable_multiplexer_nav_when_zoomed = true,
        -- Supply a Kitty remote control password if needed,
        -- or you can also set vim.g.smart_splits_kitty_password
        -- see https://sw.kovidgoyal.net/kitty/conf/#opt-kitty.remote_control_password
        kitty_password = nil,
        -- default logging level, one of: 'trace'|'debug'|'info'|'warn'|'error'|'fatal'
        log_level = "info",
      })
      vim.keymap.set("n", "<C-h>", require("smart-splits").move_cursor_left)
      vim.keymap.set("n", "<C-j>", require("smart-splits").move_cursor_down)
      vim.keymap.set("n", "<C-k>", require("smart-splits").move_cursor_up)
      vim.keymap.set("n", "<C-l>", require("smart-splits").move_cursor_right)
    end,
  },
  {
    dir = "~/Coding/octo.nvim",
    config = get_config("octo"),
  },
  -- {
  --   "pwntester/octo.nvim",
  --   config = get_config("octo"),
  --   dependencies = {
  --     'nvim-telescope/telescope.nvim'
  --   }
  -- })
  {
    "karloskar/poetry-nvim",
    lazy = false,
  },
  -----------------------------------------------------------------------------//
  -- General plugins {{{1
  -----------------------------------------------------------------------------//

  {
    "nvim-lualine/lualine.nvim",
    dependencies = "kyazdani42/nvim-web-devicons",
    event = "BufEnter",
    config = get_config("line"),
  },

  {
    "j-hui/fidget.nvim",
    tag = "legacy",
  },

  { "tpope/vim-eunuch", lazy = false },
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    config = "vim.g.undotree_WindowLayout = 2",
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufReadPre",
    init = function()
      vim.g.indent_blankline_char = "▎"
      vim.g.indent_blankline_char_blankline = "▎"
    end,
    opts = {
      filetype_exclude = {
        "lazy",
        "man",
        "gitmessengerpopup",
        "diagnosticpopup",
        "lspinfo",
        "help",
        "neo-tree",
        "NeogitStatus",
        "checkhealth",
        "TelescopePrompt",
        "TelescopeResults",
      },
      buftype_exclude = { "terminal" },
      show_trailing_blankline_indent = false,
      use_treesitter_scope = true,
      space_char_blankline = " ",
      show_foldtext = false,
      strict_tabs = true,
      max_indent_increase = 1,
      show_current_context = false,
      show_current_context_start = false,
      context_highlight_list = { "IndentBlanklineContext" },
      viewport_buffer = 100,
    },
  },

  {
    "rcarriga/nvim-notify",
    init = function()
      local notify = require("notify")
      vim.notify = notify
    end,
  },

  {
    "karb94/neoscroll.nvim",
    event = "WinScrolled",
    keys = { "<C-u>", "<C-d>", "gg", "G" },
    opts = {
      hide_cursor = false,
    },
  },

  { "sainnhe/sonokai", lazy = conf.theme ~= "sonokai" },
  { "sainnhe/edge", lazy = conf.theme ~= "edge" },
  { "sainnhe/everforest", lazy = conf.theme ~= "everforest" },
}
