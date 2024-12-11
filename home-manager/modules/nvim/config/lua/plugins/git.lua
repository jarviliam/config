return {
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    init = function()
      require("snacks")
        .toggle({
          name = "Git Signs",
          get = function()
            return require("gitsigns.config").config.signcolumn
          end,
          set = function(state)
            require("gitsigns").toggle_signs(state)
          end,
        })
        :map("\\g")
    end,
    opts = {
      attach_to_untracked = true,
      signs = {
        add = { text = "▌", show_count = true },
        change = { text = "▌", show_count = true },
        delete = { text = "▐", show_count = true },
        topdelete = { text = "▛", show_count = true },
        changedelete = { text = "▚", show_count = true },
        untracked = { text = "┆" },
      },
      on_attach = function(bufnr)
        if vim.fn.expand("%:t") == "lsp.log" or vim.bo.filetype == "help" then
          return false
        end
        local gs = package.loaded.gitsigns

        local function map(l, r, desc, mode)
          vim.keymap.set(mode or "n", l, r, { desc = desc, buffer = bufnr })
        end

        map("<leader>gb", function()
          gs.blame_line({ full = true, ignore_whitespace = true })
        end, "Blame Line")
        map("<leader>gB", gs.toggle_current_line_blame, "Git Blame Toggle")

        map("<leader>gR", gs.reset_buffer, "Reset buffer")
        map("<leader>gp", gs.preview_hunk, "Preview hunk")
        map("<leader>gU", gs.undo_stage_hunk, "Stage hunk")
        map("<leader>gD", gs.toggle_deleted, "Git Toggle Deleted")

        map("<leader>gs", function()
          gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Stage hunk Line", { "n", "x" })

        map("<leader>gr", function()
          gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Reset Hunk Line", { "n", "x" })

        map("]h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gs.next_hunk()
          end
        end, "Next hunk")
        map("[h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gs.prev_hunk()
          end
        end, "Prev hunk")
      end,
    },
  },
  {
    "aaronhallaert/advanced-git-search.nvim",
    cmd = "AdvancedGitSearch",
    config = function()
      require("advanced_git_search.fzf").setup({
        diff_plugin = "diffview",
        keymaps = {
          toggle_date_author = "<C-w>",
          open_commit_in_browser = "<C-o>",
          copy_commit_hash = "<C-y>",
          show_entire_commit = "<C-e>",
        },
        show_builtin_git_pickers = true,
      })
    end,
    keys = { { "<leader>gS", vim.cmd.AdvancedGitSearch, desc = "Search" } },
  },
}
