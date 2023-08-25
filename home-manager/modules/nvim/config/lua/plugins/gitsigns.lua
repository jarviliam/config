return {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    dependencies = {"nvim-lua/plenary.nvim"},
    config = function ()
    local gitsigns = require("gitsigns")
      gitsigns.setup({
      signs          = {
            add          = { text = "┃" },
            change       = { text = "┃" },
            delete       = { text = "_" },
            topdelete    = { text = "‾" },
            changedelete = { text = "~" },
            untracked    = { text = "┆" },
          },
          signcolumn     = true,  -- Toggle with `:Gitsigns toggle_signs`
          numhl          = false, -- Toggle with `:Gitsigns toggle_numhl`
          linehl         = false, -- Toggle with `:Gitsigns toggle_linehl`
          word_diff      = false, -- Toggle with `:Gitsigns toggle_word_diff`
          sign_priority  = 4,
          preview_config = { border = "rounded" },
          yadm           = { enable = true, },
          current_line_blame_formatter = "<author>:<author_time:%Y-%m-%d> - <summary>",
          current_line_blame_opts      = {
            virt_text         = true,
            virt_text_pos     = "right_align",
            delay             = 1,
            ignore_whitespace = false,
          },
          on_attach = function(bufnr)
            local gs = package.loaded.gitsigns
            local function map(mode, l, r, opts)
              opts = opts or {}
              opts.buffer = bufnr
              vim.keymap.set(mode, l, r, opts)
            end
          map(
            "n",
            "<leader>ghp",
            gitsigns.preview_hunk,
            { desc = "gitsigns: preview hunk" }
          ) -- preview hunk
          map("n", "<leaderg>ghb", function()
            gitsigns.blame_line({ full = true })
          end, { desc = "gitsigns: blame current line" }) -- git blame
          map(
            "n",
            "<leader>ght",
            gitsigns.toggle_current_line_blame,
            { desc = "gitsigns: toggle blame" }
          ) -- preview hunk
          map("n", "<leader>ghd", gitsigns.diffthis, { desc = "gitsigns: diff" })
          map(
            "n",
            "<leader>ghr",
            gitsigns.reset_hunk,
            { desc = "gitsigns: reset hunk" }
          )
          map(
            "n",
            "<leader>ghR",
            gitsigns.reset_buffer,
            { desc = "gitsigns: reset buffer" }
          ) -- reset buffer
          map(
            "n",
            "<leader>ghu",
            gitsigns.undo_stage_hunk,
            { desc = "gitsigns: undo stage" }
          ) -- undo last stage hunk
          map("n", "<leader>ghs", gitsigns.stage_hunk, { desc = "gitsigns: stage" }) -- git stage hunk
          map(
            "n",
            "<leader>ghS",
            gitsigns.stage_buffer,
            { desc = "gitsigns: stage buffer" }
          ) -- git stage buffer
          map("n", "]c", function()
            if vim.wo.diff then return "]c" end
              vim.schedule(function() gs.next_hunk() end)
              return "<Ignore>"
              end, {expr=true, desc = "gitsigns: go to prev hunk" }) -- previous hunk
          map("n", "[c", function()
              if vim.wo.diff then return "[c" end
              vim.schedule(function() gs.prev_hunk() end)
              return "<Ignore>"
            end, { expr = true, desc = "Previous hunk" })
          map("n", "<leader>ghq", function()
            gitsigns.setqflist("all")
          end, { desc = "gitsigns: list modified in quickfix" })
        end,
      })
  end
}