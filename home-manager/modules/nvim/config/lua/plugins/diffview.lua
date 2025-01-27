local set = vim.keymap.set
local function nset(key, cmd, desc)
  set("n", "<leader>gd" .. key, cmd, { desc = desc, silent = true })
end

local function apply_keymaps()
  nset("q", ":DiffviewClose<CR>", "Close Diffview tab")
  nset("h", ":DiffviewFileHistory %<CR>", "File history")
  nset("H", ":DiffviewFileHistory<CR>", "Repo history")
  nset("o", ":lua require('diffview').open(require('utils').get_trunk_branch())<CR>", "DiffviewOpen")
end

return {
  "sindrets/diffview.nvim",
  lazy = false, -- Diffview has lazyloading
  keys = {
    { "<leader>gf", "<cmd>DiffviewFileHistory<cr>", desc = "File history" },
    { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diff view" },
  },
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local actions = require("diffview.actions")
    require("diffview").setup({
      diff_binaries = false, -- Show diffs for binaries
      enhanced_diff_hl = true, -- See ':h diffview-config-enhanced_diff_hl'
      use_icons = true, -- Requires nvim-web-devicons
      icons = { -- Only applies when use_icons is true.
        folder_closed = "",
        folder_open = "",
      },
      signs = {
        fold_closed = "",
        fold_open = "",
      },
      file_panel = {
        listing_style = "tree", -- One of 'list' or 'tree'
        tree_options = { -- Only applies when listing_style is 'tree'
          flatten_dirs = true, -- Flatten dirs that only contain one single dir
          folder_statuses = "only_folded", -- One of 'never', 'only_folded' or 'always'.
        },
        win_config = { -- See ':h diffview-config-win_config'
          position = "left",
          width = 35,
        },
      },
      file_history_panel = {
        log_options = {
          git = {
            single_file = {
              max_count = 256, -- Limit the number of commits
              follow = false, -- Follow renames (only for single file)
              all = false, -- Include all refs under 'refs/' including HEAD
              merges = false, -- List only merge commits
              no_merges = false, -- List no merge commits
              reverse = false, -- List commits in reverse order
            },
            multi_file = {
              max_count = 256, -- Limit the number of commits
              follow = false, -- Follow renames (only for single file)
              all = false, -- Include all refs under 'refs/' including HEAD
              merges = false, -- List only merge commits
              no_merges = false, -- List no merge commits
              reverse = false, -- List commits in reverse order
            },
          },
        },
        win_config = { -- See ':h diffview-config-win_config'
          position = "bottom",
          height = 16,
        },
      },
      default_args = { -- Default args prepended to the arg-list for the listed commands
        DiffviewFileHistory = { "%" },
      },
      hooks = {
        diff_buf_read = function(bufnr)
          vim.b[bufnr].miniclue_config = {
            clues = {
              { mode = "n", keys = "<leader>G", desc = "+diffview" },
            },
          }
        end,
      },
      keymaps = {
        disable_defaults = false, -- Disable the default keymaps
        view = {
          -- The `view` bindings are active in the diff buffers, only when the current
          -- tabpage is a Diffview.
          ["<tab>"] = actions.select_next_entry, -- Open the diff for the next file
          ["<s-tab>"] = actions.select_prev_entry, -- Open the diff for the previous file
          ["gf"] = actions.goto_file, -- Open the file in a new split in previous tabpage
          ["<C-w><C-f>"] = actions.goto_file_split, -- Open the file in a new split
          ["<C-w>gf"] = actions.goto_file_tab, -- Open the file in a new tabpage
          ["<leader>e"] = actions.focus_files, -- Bring focus to the files panel
          ["<leader>b"] = actions.toggle_files, -- Toggle the files panel.
        },
        file_panel = {
          ["j"] = actions.next_entry, -- Bring the cursor to the next file entry
          ["<down>"] = actions.next_entry,
          ["k"] = actions.prev_entry, -- Bring the cursor to the previous file entry.
          ["<up>"] = actions.prev_entry,
          ["<cr>"] = actions.select_entry, -- Open the diff for the selected entry.
          ["o"] = actions.select_entry,
          ["<2-LeftMouse>"] = actions.select_entry,
          ["-"] = actions.toggle_stage_entry, -- Stage / unstage the selected entry.
          ["S"] = actions.stage_all, -- Stage all entries.
          ["U"] = actions.unstage_all, -- Unstage all entries.
          ["X"] = actions.restore_entry, -- Restore entry to the state on the left side.
          ["R"] = actions.refresh_files, -- Update stats and entries in the file list.
          ["L"] = actions.open_commit_log, -- Open the commit log panel.
          ["<c-b>"] = actions.scroll_view(-0.25), -- Scroll the view up
          ["<c-f>"] = actions.scroll_view(0.25), -- Scroll the view down
          ["<tab>"] = actions.select_next_entry,
          ["<s-tab>"] = actions.select_prev_entry,
          ["gf"] = actions.goto_file,
          ["<C-w><C-f>"] = actions.goto_file_split,
          ["<C-w>gf"] = actions.goto_file_tab,
          ["i"] = actions.listing_style, -- Toggle between 'list' and 'tree' views
          ["f"] = actions.toggle_flatten_dirs, -- Flatten empty subdirectories in tree listing style.
          ["<leader>e"] = actions.focus_files,
          ["<leader>b"] = actions.toggle_files,
        },
        file_history_panel = {
          ["g!"] = actions.options, -- Open the option panel
          ["<C-A-d>"] = actions.open_in_diffview, -- Open the entry under the cursor in a diffview
          ["y"] = actions.copy_hash, -- Copy the commit hash of the entry under the cursor
          ["L"] = actions.open_commit_log,
          ["zR"] = actions.open_all_folds,
          ["zM"] = actions.close_all_folds,
          ["j"] = actions.next_entry,
          ["<down>"] = actions.next_entry,
          ["k"] = actions.prev_entry,
          ["<up>"] = actions.prev_entry,
          ["<cr>"] = actions.select_entry,
          ["o"] = actions.select_entry,
          ["<2-LeftMouse>"] = actions.select_entry,
          ["<c-b>"] = actions.scroll_view(-0.25),
          ["<c-f>"] = actions.scroll_view(0.25),
          ["<tab>"] = actions.select_next_entry,
          ["<s-tab>"] = actions.select_prev_entry,
          ["gf"] = actions.goto_file,
          ["<C-w><C-f>"] = actions.goto_file_split,
          ["<C-w>gf"] = actions.goto_file_tab,
          ["<leader>e"] = actions.focus_files,
          ["<leader>b"] = actions.toggle_files,
        },
        option_panel = {
          ["<tab>"] = actions.select_entry,
          ["q"] = actions.close,
        },
      },
    })
    apply_keymaps()
  end,
}
