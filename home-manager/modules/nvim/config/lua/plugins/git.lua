return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufWritePre", "BufNewFile" },
    enabled = false,
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
      gh = true,
      _new_sign_calc = true,
      current_line_blame = true,
      trouble = true,
      on_attach = function(bufnr)
        if vim.fn.expand("%:t") == "lsp.log" or vim.bo.filetype == "help" then
          return false
        end
        local gs = package.loaded.gitsigns

        Snacks.toggle({
          name = "Git Signs",
          get = function()
            return require("gitsigns.config").config.signcolumn
          end,
          set = function(state)
            require("gitsigns").toggle_signs(state)
          end,
        }):map("\\g")

        local function bmap(keys, func, desc, mode)
          vim.keymap.set(mode or "n", keys, func, { desc = desc, buffer = bufnr })
        end

        local function stage_or_reset_hunk(action, desc)
          return function()
            gs[action]({ vim.fn.line("."), vim.fn.line("v") })
          end,
            desc,
            { "n", "x" }
        end

        if vim.fn.expand("%:t") == "lsp.log" or vim.bo.filetype == "help" then
          return false
        end

        bmap("<leader>gb", function()
          gs.blame_line({ full = true, ignore_whitespace = true })
        end, "Blame Line")
        bmap("<leader>gB", gs.toggle_current_line_blame, "Git Blame Toggle")
        bmap("<leader>gR", gs.reset_buffer, "Reset buffer")
        bmap("<leader>gp", gs.preview_hunk, "Preview hunk")
        bmap("<leader>gU", gs.undo_stage_hunk, "Stage hunk")
        bmap("<leader>gD", gs.toggle_deleted, "Git Toggle Deleted")
        bmap("<leader>gs", stage_or_reset_hunk("stage_hunk", "Stage hunk Line"))
        bmap("<leader>gr", stage_or_reset_hunk("reset_hunk", "Reset Hunk Line"))

        bmap("]h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gs.next_hunk()
          end
        end, "Next hunk")

        bmap("[h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gs.prev_hunk()
          end
        end, "Prev hunk")

        vim.b[bufnr].miniclue_config = {
          clues = {
            { mode = "n", keys = "<leader>g", desc = "+git" },
            { mode = "x", keys = "<leader>g", desc = "+git" },
          },
        }
      end,
    },
  },
}
