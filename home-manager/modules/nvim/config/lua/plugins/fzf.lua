return {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
    lazy = false,
    keys = {
      { "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Find File" },
      { "<leader>/", "<cmd>FzfLua live_grep_glob<cr>", desc = "Live grep" },
      { "<leader>fm", "<cmd>FzfLua marks<cr>", desc = "marks" },
      { "<leader>f?", "<cmd>FzfLua builtin<cr>", desc = "builtin" },
      { "<leader>fM", "<cmd>FzfLua man_pages<cr>", desc = "man_pages" },
      { "<leader>fw", "<cmd>FzfLua grep_cword<cr>", desc = "grep <word> (project)" },
      { "<leader>fW", "<cmd>FzfLua grep_cWORD<cr>", desc = "grep <WORD> (project)" },
      { "<leader>fz", "<cmd>FzfLua spell_suggest<cr>", desc = "spell" },
      { "<leader>fg", "<cmd>FzfLua git_files<cr>", desc = "Find Files (Git)" },
      { "<leader>f/", "<cmd>FzfLua lgrep_curbuf<cr>", desc = "live grep (buffer)" },
      { "<leader>fj", "<cmd>FzfLua jumps<cr>", desc = "jumps" },
      { "<leader>fr", "<cmd>FzfLua resume<cr>", desc = "resume" },
      { "<leader>fb", "<cmd>FzfLua buffers<cr>", desc = "Buffers" },
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
        lsp = {
          code_actions = {
            previewer = "codeaction_native",
            preview_pager = "delta --side-by-side --width=$FZF_PREVIEW_COLUMNS --hunk-header-style='omit' --file-style='omit'",
          },
        },
      }
    end,
  }
