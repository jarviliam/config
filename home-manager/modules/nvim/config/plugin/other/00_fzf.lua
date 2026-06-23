local methods = vim.lsp.protocol.Methods
Config.now(function()
  vim.pack.add({ "https://github.com/ibhagwan/fzf-lua" })

  local fzf = require("fzf-lua")
  local actions = require("fzf-lua.actions")

  fzf.setup({
    { "fzf-vim", "hide" },
    fzf_colors = true,
    defaults = {
      cwd_header = true,
      file_icons = "mini",
      formatter = "path.filename_first",
      headers = { "actions", "cwd" },
      no_header_i = true, -- hide interactive header
      winopts = {
        preview = {
          default = "bat_native",
          hidden = false,
        },
      },
    },
    keymap = {
      fzf = {
        true,
        ["ctrl-d"] = "preview-page-down",
        ["ctrl-u"] = "preview-page-up",
        ["ctrl-q"] = "select-all+accept",
      },
    },
    fzf_opts = {
      ["--info"] = "default",
      ["--layout"] = "reverse-list",
    },
    helptags = {
      actions = {
        -- Open help pages in a vertical split.
        ["default"] = actions.help_vert,
      },
    },
    files = {
      cwd_prompt = false,
      winopts = {},
    },
    lsp = {
      document_symbols = {
        fzf_cli_args = "--nth 2..",
        ignore_current_line = true,
        includeDeclaration = false,
        jump_to_single_result = true,
      },
    },
    dignostics = { multiline = 1 },
    oldfiles = {
      include_current_session = true,
      winopts = {
        preview = { hidden = true },
      },
    },
  })

  Config.find_todo = function()
    fzf.grep({
      search = "(TODO|HACK|WARNING|NOTE|FIX|BUG|PERF):",
    })
  end

  if Config.picker_name == "fzf" then
    Config.picker = {
      commands = fzf.commands,
      command_history = fzf.command_history,
      live_grep = fzf.live_grep,
      files = fzf.files,
      files_root = nil,
      resume = fzf.resume,
      buffers = function()
        fzf.buffers({
          sort_lastused = true,
          sort_mru = true,
        })
      end,
      buffer_lines = fzf.blines,

      git = {
        files = fzf.git_files,
        buffer_commits = fzf.git_bcommits,
      },

      grep = {
        cword = fzf.grep_cword,
        cWORD = fzf.grep_cWORD,
        lines = fzf.lines,
      },

      lsp = {},

      registers = fzf.registers,
      search_history = fzf.search_history,

      autocmds = fzf.autocmds,

      diagnostics = {
        document = fzf.diagnostics_document,
        workspace = fzf.diagnostics_workspace,
      },

      help = {
        tags = fzf.help_tags,
        man = fzf.man_pages,
      },

      highlights = fzf.highlights,
      builtin = fzf.builtin,

      keymaps = fzf.keymaps,
      quickfix = fzf.quickfix,

      visit_paths = {
        cwd = nil,
        all = nil,
      },
    }
  end

  ---@param lhs string
  ---@param rhs string|function
  ---@param opts string|table
  ---@param mode? string|string[]
  local function keymap(lhs, rhs, opts, mode)
    opts = type(opts) == "string" and { desc = opts } or vim.tbl_extend("error", opts --[[@as table]], {})
    vim.keymap.set(mode or "n", lhs, rhs, opts)
  end

  if Config.picker == "fzf" then
    Config.new_autocmd("LspAttach", {
      callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        keymap("grr", function()
          fzf.lsp_references({ jump1 = true })
        end, "Go to references")

        keymap("gy", "<cmd>FzfLua lsp_typedefs<cr>", "goto type definition [LSP]")

        assert(client)
        if client:supports_method(methods.textDocument_implementation) then
          local op = function()
            fzf.lsp_implementations({ jump1 = true })
          end
          keymap("<leader>gi", op, "Go to implementation")
        end

        if client:supports_method(methods.textDocument_definition) then
          keymap("gd", function()
            fzf.lsp_definitions({ jump1 = true })
          end, "Go to definition")
          keymap("gD", function()
            fzf.lsp_definitions({ jump1 = false })
          end, "Peek definition")
        end
      end,
    })
  end
end)
