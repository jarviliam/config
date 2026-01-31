local methods = vim.lsp.protocol.Methods
Config.now(function()
  vim.pack.add({ "https://github.com/ibhagwan/fzf-lua" }, { load = true })

  local fzf = require("fzf-lua")
  local actions = require("fzf-lua.actions")

  fzf.setup({
    { "border-fused", "hide" },
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
      winopts = {
        preview = { hidden = true },
      },
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

  fzf.register_ui_select()

  Config.find_todo = function()
    fzf.grep({
      search = "(TODO|HACK|WARNING|NOTE|FIX|BUG|PERF):",
    })
  end

  ---@param lhs string
  ---@param rhs string|function
  ---@param opts string|table
  ---@param mode? string|string[]
  local function keymap(lhs, rhs, opts, mode)
    opts = type(opts) == "string" and { desc = opts }
      or vim.tbl_extend("error", opts --[[@as table]], { buffer = bufnr })
    vim.keymap.set(mode or "n", lhs, rhs, opts)
  end

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
        keymap("gi", op, "Go to implementation")
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
end)
