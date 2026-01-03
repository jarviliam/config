---@type LazySpec
return {
  "ibhagwan/fzf-lua",
  cmd = "FzfLua",
  init = function()
    require("fzf-lua").register_ui_select()
  end,
  lazy = false,
  keys = {
    { "<leader>:", "<cmd>FzfLua command_history<cr>", desc = "Command History" },
    { "<leader>/", "<cmd>FzfLua live_grep<cr>", desc = "Grep (Root Dir)" },
    { "<leader><space>", "<cmd>FzfLua files<cr>", desc = "Find Files (Root Dir)" },
    { "<leader>f;", "<cmd>FzfLua resume<cr>", desc = "Resume Picker" },

    { "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Find File" },
    {
      "<leader>fF",
      function()
        require("fzf-lua").files({ cwd = vim.fn.getcwd() })
      end,
      desc = "Find File (Cwd)",
    },
    { "<leader>fb", "<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>", desc = "Buffer Picker" },
    { "<leader>fC", "<cmd>FzfLua git_bcommits<cr>", desc = "Buffer Commits" },
    { "<leader>fg", "<cmd>FzfLua git_files<cr>", desc = "Find Files (Git)" },
    { "<leader>sb", "<cmd>FzfLua blines<cr>", desc = "Buffer Lines" },
    { "<leader>sB", "<cmd>FzfLua lines<cr>", desc = "Grep Open Buffers" },
    {
      "<leader>sG",
      function()
        require("fzf-lua").live_grep({ cwd_only = true })
      end,
      desc = "Grep (Cwd)",
    },

    {
      "<leader>f/",
      function()
        require("fzf-lua").lgrep_curbuf({
          winopts = {
            preview = {
              layout = "vertical",
              vertical = "up:60%",
            },
          },
        })
      end,
      desc = "live grep (buffer)",
    },
    {
      "<leader>fr",
      function()
        vim.cmd("rshada!")
        require("fzf-lua").oldfiles()
      end,
      desc = "Recently Opened Files",
    },
    -- search
    { "<leader>sw", "<cmd>FzfLua grep_cword<cr>", desc = "grep <word> (project)" },
    { "<leader>sW", "<cmd>FzfLua grep_cWORD<cr>", desc = "grep <WORD> (project)" },

    { '<leader>s"', "<cmd>FzfLua registers<cr>", desc = "Registers" },
    { "<leader>s/", "<cmd>FzfLua search_history<cr>", desc = "Search History" },
    { "<leader>sa", "<cmd>FzfLua autocmds<cr>", desc = "Auto Commands" },
    { "<leader>sc", "<cmd>FzfLua command_history<cr>", desc = "Command History" },
    { "<leader>sC", "<cmd>FzfLua commands<cr>", desc = "Commands" },
    { "<leader>sd", "<cmd>FzfLua diagnostics_document<cr>", desc = "Document Diagnostics" },
    { "<leader>sD", "<cmd>FzfLua diagnostics_workspace<cr>", desc = "Workspace Diagnostics" },
    { "<leader>sh", "<cmd>FzfLua help_tags<cr>", desc = "Help Pages" },
    { "<leader>sH", "<cmd>FzfLua highlights<cr>", desc = "Search Highlight Groups" },
    { "<leader>sj", "<cmd>FzfLua jumps<cr>", desc = "Jumps" },
    { "<leader>sm", "<cmd>FzfLua marks<cr>", desc = "Marks" },

    { "<leader>f?", "<cmd>FzfLua builtin<cr>", desc = "builtin" },
    { "<leader>sM", "<cmd>FzfLua man_pages<cr>", desc = "Man Pages" },

    -- git
    { "<leader>gd", "<cmd>FzfLua git_hunks<cr>", desc = "Git Diff (hunks)" },
    {
      "<leader>gD",
      function()
        require("fzf-lua").git_diff({ ref = "origin" })
      end,
      desc = "Git Diff (origin)",
    },
    { "<leader>sk", "<cmd>FzfLua keymaps<cr>", desc = "Keymaps" },
    { "<leader>sq", "<cmd>FzfLua quickfix<cr>", desc = "Quickfix List" },
    {
      "<leader>ss",
      function()
        require("fzf-lua").lsp_document_symbols({})
      end,
      desc = "Goto Symbol",
    },
    {
      "<leader>sS",
      function()
        require("fzf-lua").lsp_live_workspace_symbols({})
      end,
      desc = "Goto Symbol (Workspace)",
    },
  },
  opts = function()
    local actions = require("fzf-lua.actions")
    return {
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
    }
  end,
}
