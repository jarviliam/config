Config.now(function()
  -- vim.pack.add({ "https://codeberg.org/comfysage/artio.nvim" })
  vim.cmd.packadd("artio.nvim")
  local artio = require("artio")
  artio.setup({
    opts = {
      preselect = true, -- whether to preselect the first match
      bottom = true, -- whether to draw the prompt at the bottom
      shrink = true, -- whether the window should shrink to fit the matches
      promptprefix = "", -- prefix for the prompt
      prompt_title = true, -- whether to draw the prompt title
      pointer = "", -- pointer for the selected match
      marker = "│", -- prefix for marked items
      infolist = { "list" }, -- index: [1] list: (4/5)
      use_icons = true, -- requires mini.icons
    },
    win = {
      height = 12,
      hidestatusline = false, -- works best with laststatus=3
    },
    -- NOTE: if you override the mappings, make sure to provide keys for all actions
    mappings = {
      ["<down>"] = "down",
      ["<up>"] = "up",
      ["<cr>"] = "accept",
      ["<esc>"] = "cancel",
      ["<tab>"] = "mark",
      ["<c-g>"] = "togglelive",
      ["<c-l>"] = "togglepreview",
      ["<c-q>"] = "setqflist",
      ["<m-q>"] = "setqflistmark",
    },
  })

  if Config.picker_name == "artio" then
    local builtins = require("artio.builtins")
    Config.picker = {
      commands = builtins.commands,
      command_history = nil,
      live_grep = nil,
      files = builtins.files,
      files_root = nil,
      resume = artio.resume,
      buffers = function()
        -- fzf.buffers({
        --   sort_lastused = true,
        --   sort_mru = true,
        -- })
      end,
      buffer_lines = nil,

      git = {
        files = nil,
        buffer_commits = nil,
      },

      grep = {
        cword = nil,
        cWORD = nil,
        lines = nil,
      },

      lsp = {},

      registers = nil,
      search_history = nil,

      autocmds = nil,

      diagnostics = {
        document = nil,
        workspace = nil,
      },

      help = {
        tags = builtins.helptags,
        man = nil,
      },

      highlights = builtins.highlights,
      builtin = builtins.builtins,

      keymaps = builtins.keymaps,
      quickfix = builtins.quickfix,

      visit_paths = {
        cwd = nil,
        all = nil,
      },
    }
  end
end)
