Config.later(function()
  local pick = require("mini.pick")
  pick.setup({})
  require("mini.extra").setup()

  MiniPick.registry.cword = function(opts)
    MiniPick.builtin.grep({ pattern = vim.fn.expand("<cword>") })
  end

  MiniPick.registry.cWORD = function(opts)
    MiniPick.builtin.grep({ pattern = vim.fn.expand("<cWORD>") })
  end

  if Config.picker_name == "mini" then
    Config.picker = {
      commands = MiniExtra.pickers.commands,
      command_history = function()
        MiniExtra.pickers.history({ scope = ":" })
      end,
      files = MiniPick.builtin.files,
      live_grep = MiniPick.builtin.grep_live,
      resume = MiniPick.builtin.resume,
      grep = {
        cword = function() end,
      },
      buffers = MiniPick.builtin.buffers,
      buffer_lines = MiniExtra.pickers.buf_lines,

      git = {
        files = MiniExtra.pickers.git_files,
        buffer_commits = function()
          MiniExtra.pickers.git_commits({ path = "%" })
        end,
      },
      help = {
        tags = MiniPick.builtin.help,
        man = MiniExtra.pickers.manpages,
      },
      registers = MiniExtra.pickers.registers,

      search_history = function()
        MiniExtra.pickers.history({ scope = "/" })
      end,
      highlights = MiniExtra.pickers.hl_groups,

      keymaps = MiniExtra.pickers.keymaps,
      quickfix = function()
        MiniExtra.pickers.list({ scope = "quickfix" })
      end,
    }
  end
end)
