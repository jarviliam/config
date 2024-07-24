return {
  "ibhagwan/fzf-lua",
  cmd = "FzfLua",
  lazy = false,
  keys = {
    { "<leader>:", "<cmd>FzfLua command_history<cr>", desc = "Command History" },
    { "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Find File" },
    { "<leader>/", "<cmd>FzfLua live_grep_glob<cr>", desc = "Live grep" },
    { "<leader>sm", "<cmd>FzfLua marks<cr>", desc = "Jump to Mark" },
    { "<leader>f?", "<cmd>FzfLua builtin<cr>", desc = "builtin" },
    { "<leader>sM", "<cmd>FzfLua man_pages<cr>", desc = "Man Pages" },
    { "<leader>fw", "<cmd>FzfLua grep_cword<cr>", desc = "grep <word> (project)" },
    { "<leader>fW", "<cmd>FzfLua grep_cWORD<cr>", desc = "grep <WORD> (project)" },
    { "<leader>fz", "<cmd>FzfLua spell_suggest<cr>", desc = "spell" },
    { "<leader>fg", "<cmd>FzfLua git_files<cr>", desc = "Find Files (Git)" },
    { '<leader>s"', "<cmd>FzfLua registers<cr>", desc = "Registers" },
    { "<leader>sa", "<cmd>FzfLua autocmds<cr>", desc = "Auto Commands" },
    { "<leader>sC", "<cmd>FzfLua commands<cr>", desc = "Commands" },
    { "<leader>sd", "<cmd>FzfLua diagnostics_document<cr>", desc = "Document Diagnostics" },
    { "<leader>sD", "<cmd>FzfLua diagnostics_workspace<cr>", desc = "Workspace Diagnostics" },
    { "<leader>sh", "<cmd>FzfLua help_tags<cr>", desc = "Help Pages" },
    { "<leader>f/", "<cmd>FzfLua lgrep_curbuf<cr>", desc = "live grep (buffer)" },
    { "<leader>sH", "<cmd>FzfLua highlights<cr>", desc = "Search Highlight Groups" },
    { "<leader>sj", "<cmd>FzfLua jumps<cr>", desc = "Jumplist" },
    { "<leader>sR", "<cmd>FzfLua resume<cr>", desc = "resume" },
    { "<leader>sk", "<cmd>FzfLua keymaps<cr>", desc = "Key Maps" },
    { "<leader>sq", "<cmd>FzfLua quickfix<cr>", desc = "Quickfix List" },
    { "<leader>sl", "<cmd>FzfLua loclist<cr>", desc = "Location List" },
    { "<leader>fb", "<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>", desc = "Buffers" },
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
      "fzf-native",
      fzf_colors = true,
      fzf_opts = {
        ["--info"] = "default",
        ["--layout"] = "reverse-list",
      },
      defaults = { formatter = "path.filename_first" },
      helptags = {
        actions = {
          -- Open help pages in a vertical split.
          ["default"] = actions.help_vert,
        },
      },
      files = {
        cwd_prompt = false,
        actions = {
          ["alt-i"] = { actions.toggle_ignore },
          ["alt-h"] = { actions.toggle_hidden },
        },
      },
      grep = {
        actions = {
          ["alt-i"] = { actions.toggle_ignore },
          ["alt-h"] = { actions.toggle_hidden },
        },
      },
      lsp = {
        code_actions = {
          previewer = vim.fn.executable("delta") == 1 and "codeaction_native" or nil,
        },
      },
    }
  end,
}
