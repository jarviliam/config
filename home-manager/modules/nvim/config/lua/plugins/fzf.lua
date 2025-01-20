local internal_substitutions = {
  { find = ":/", replace = "__" },
  { find = "/", replace = "_" },
}

local function substitute_path(path, reverse)
  reverse = reverse or false
  for _, substitution in ipairs(internal_substitutions) do
    if reverse then
      path = path:gsub(substitution.replace, substitution.find)
    else
      path = path:gsub(substitution.find, substitution.path)
    end
  end
  return path
end

local function fzf_session()
  local fzf_lua = require("fzf-lua")
  local resession = require("resession")
  local list = resession.list({})
  local formatted_list = vim.tbl_map(function(value)
    return substitute_path(value, true)
  end, list)
  fzf_lua.fzf_exec(formatted_list, {
    actions = {
      ["ctrl-d"] = function(selected)
        local origin_session = substitute_path(selected, false)
        resession.delete(origin_session)
      end,
      ["default"] = function(selected)
        local origin_session = substitute_path(selected, false)
        resession.load(origin_session)
      end,
    },
  })
end

local function reload_lazy()
  local plugins = require("lazy").plugins()
  local names = {}
  for _, plugin in ipairs(plugins) do
    table.insert(names, plugin.name)
  end
  require("fzf-lua").fzf_exec(names, {
    prompt = "Select a plugin > ",
    actions = {
      ["default"] = function(selected)
        vim.cmd("Lazy reload " .. selected[1])
      end,
    },
    winopts = {
      title = " Reload Plugins ",
      title_pos = "center",
      preview = { hidden = "hidden" },
      height = 0.50, -- window height
      width = 0.40, -- window width
      row = 0.50, -- window row position (0=top, 1=bottom)
      col = 0.50, -- window col position (0=left, 1=right)
    },
  })
end
return {
  "ibhagwan/fzf-lua",
  cmd = "FzfLua",
  lazy = false,
  keys = {
    { "<leader>:", "<cmd>FzfLua command_history<cr>", desc = "Command History" },
    { "<leader>f;", "<cmd>FzfLua resume<cr>", desc = "Resume Picker" },

    { "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Find File" },
    { "<leader>fb", "<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>", desc = "Buffer Picker" },
    { "<leader>fC", "<cmd>FzfLua git_bcommits<cr>", desc = "Buffer Commits" },

    { "<leader>f/", "<cmd>FzfLua lgrep_curbuf<cr>", desc = "live grep (buffer)" },
    { "<leader>/", "<cmd>FzfLua live_grep_glob<cr>", desc = "Live grep" },

    { "<leader>fw", "<cmd>FzfLua grep_cword<cr>", desc = "grep <word> (project)" },
    { "<leader>fW", "<cmd>FzfLua grep_cWORD<cr>", desc = "grep <WORD> (project)" },

    { '<leader>s"', "<cmd>FzfLua registers<cr>", desc = "Registers" },
    { "<leader>sa", "<cmd>FzfLua autocmds<cr>", desc = "Auto Commands" },
    { "<leader>sC", "<cmd>FzfLua commands<cr>", desc = "Commands" },
    { "<leader>sm", "<cmd>FzfLua marks<cr>", desc = "Jump to Mark" },

    { "<leader>f?", "<cmd>FzfLua builtin<cr>", desc = "builtin" },
    { "<leader>sM", "<cmd>FzfLua man_pages<cr>", desc = "Man Pages" },

    { "<leader>fG", "<cmd>FzfLua git_files<cr>", desc = "Find Files (Git)" },
    { "<leader>fc", "<cmd>FzfLua git_commits<cr>", desc = "Git Commits" },
    { "<leader>gb", "<cmd>FzfLua git_branches<cr>", desc = "Find Branches (Git)" },

    { "<leader>sd", "<cmd>FzfLua diagnostics_document<cr>", desc = "Document Diagnostics" },
    { "<leader>sD", "<cmd>FzfLua diagnostics_workspace<cr>", desc = "Workspace Diagnostics" },
    { "<leader>sh", "<cmd>FzfLua help_tags<cr>", desc = "Help Pages" },
    { "<leader>sH", "<cmd>FzfLua highlights<cr>", desc = "Search Highlight Groups" },
    { "<leader>sj", "<cmd>FzfLua jumps<cr>", desc = "Jumplist" },
    { "<leader>fk", "<cmd>FzfLua keymaps<cr>", desc = "Key Maps" },
    { "<leader>fq", "<cmd>FzfLua quickfix<cr>", desc = "Quickfix List" },
    { "<F7>", fzf_session, desc = "Sessions" },
    { "<leader>lr", reload_lazy, desc = "Lazy Reload" },
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
      "ivy",
      fzf_colors = true,
      defaults = {
        cwd_header = true,
        file_icons = "mini",
        formatter = "path.filename_first",
        headers = { "actions", "cwd" },
        no_header_i = true, -- hide interactive header
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
        actions = {
          ["alt-i"] = { actions.toggle_ignore },
          ["alt-h"] = { actions.toggle_hidden },
          ["alt-t"] = { require("trouble.sources.fzf").actions.open },
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
        document_symbols = {
          fzf_cli_args = "--nth 2..",
          ignore_current_line = true,
          includeDeclaration = false,
          jump_to_single_result = true,
        },
      },
    }
  end,
}
