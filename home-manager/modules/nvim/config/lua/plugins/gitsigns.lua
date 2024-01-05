return {
  "lewis6991/gitsigns.nvim",
  event = "BufReadPre",
  opts = {
    signs = {
      add = { text = "▌", show_count = true },
      change = { text = "▌", show_count = true },
      delete = { text = "▐", show_count = true },
      topdelete = { text = "▛", show_count = true },
      changedelete = { text = "▚", show_count = true },
      untracked = { text = "┆" },
    },
    update_debounce = 500,
    signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
    numhl = true, -- Toggle with `:Gitsigns toggle_numhl`
    sign_priority = 10,
    count_chars = { -- {{{
      [1] = "",
      [2] = "₂",
      [3] = "₃",
      [4] = "₄",
      [5] = "₅",
      [6] = "₆",
      [7] = "₇",
      [8] = "₈",
      [9] = "₉",
      ["+"] = "₊",
    }, -- }}}
    diff_opts = { -- {{{
      internal = true,
      algorithm = "patience",
      indent_heuristic = true,
      linematch = 60,
    }, -- }}}
    on_attach = function(bufnr)
      local name = vim.api.nvim_buf_get_name(bufnr)
      if vim.fn.expand("%:t") == "lsp.log" or vim.bo.filetype == "help" then
        return false
      end
      local size = vim.fn.getfsize(name)
      if size > 1024 * 1024 * 5 then
        return false
      end
      local gs = package.loaded.gitsigns

      vim.b[bufnr].miniclue_config = {
        clues = {
          { mode = "n", keys = "<leader>h", desc = "+hunk" },
          { mode = "x", keys = "<leader>h", desc = "+hunk" },
        },
      }
      vim.keymap.set("n", "<leader>hS", gs.toggle_signs, { desc = "Toggle signs" })
      vim.keymap.set("n", "<leader>hb", gs.blame_line, { desc = "Blame line" })
      vim.keymap.set("n", "<leader>hs", gs.stage_hunk, { desc = "Stage hunk" })
      vim.keymap.set("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Undo last staged hunk" })
      vim.keymap.set("n", "<leader>hr", gs.reset_hunk, { desc = "Reset hunk" })
      vim.keymap.set("n", "<leader>hR", gs.reset_buffer, { desc = "Reset buffer" })
      vim.keymap.set("n", "<leader>hp", gs.preview_hunk, { desc = "Preview hunk" })
      local next_hunk = gs.next_hunk
      local prev_hunk = gs.prev_hunk
      local ok, ts_repeat_move = pcall(require, "nvim-treesitter.textobjects.repeatable_move")
      if ok then
        next_hunk, prev_hunk = ts_repeat_move.make_repeatable_move_pair(gs.next_hunk, gs.prev_hunk)
      end
      vim.keymap.set("n", "]g", next_hunk, { desc = "Next hunk" })
      vim.keymap.set("n", "[g", prev_hunk, { desc = "Prev hunk" })
    end,
  },
}
