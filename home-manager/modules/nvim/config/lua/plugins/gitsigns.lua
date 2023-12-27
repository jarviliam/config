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
      local utils = require("core.utils")
      local name = vim.api.nvim_buf_get_name(bufnr)
      if vim.fn.expand("%:t") == "lsp.log" or vim.bo.filetype == "help" then
        return false
      end
      local size = vim.fn.getfsize(name)
      if size > 1024 * 1024 * 5 then
        return false
      end
      local gs = package.loaded.gitsigns
      vim.keymap.set("n", "<leader>gs", gs.toggle_signs, { desc = "toggle gitsigns sign column" })
      vim.keymap.set("n", "<leader>hb", gs.blame_line, { desc = "blame line" })
      vim.keymap.set("n", "<leader>hs", gs.stage_hunk, { desc = "stage hunk" })
      vim.keymap.set("n", "<leader>hu", gs.undo_stage_hunk, { desc = "undo last staged hunk" })
      vim.keymap.set("n", "<leader>hr", gs.reset_hunk, { desc = "reset hunk" })
      vim.keymap.set("n", "<leader>hR", gs.reset_buffer, { desc = "reset buffer" })
      vim.keymap.set("n", "<leader>hp", gs.preview_hunk, { desc = "preview hunk" })
      vim.keymap.set({ "o", "x" }, "ih", function()
        require("gitsigns.actions").select_hunk()
      end, { desc = "in hunk" })
      vim.keymap.set({ "o", "x" }, "ah", function()
        require("gitsigns.actions").select_hunk()
      end, { desc = "around hunk" })
      local next_hunk = gs.next_hunk
      local prev_hunk = gs.prev_hunk
      local ok, ts_repeat_move = pcall(require, "nvim-treesitter.textobjects.repeatable_move")
      if ok then
        next_hunk, prev_hunk = ts_repeat_move.make_repeatable_move_pair(gs.next_hunk, gs.prev_hunk)
      end
      vim.keymap.set({ "n", "x", "o" }, "]g", function()
        utils.call_and_center(next_hunk)
      end, { desc = "go to next change" })
      vim.keymap.set({ "n", "x", "o" }, "[g", function()
        utils.call_and_centre(prev_hunk)
      end, { desc = "go to previous change" })
    end,
  },
}
