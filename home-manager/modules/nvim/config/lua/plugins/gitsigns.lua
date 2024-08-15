return {
  {
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
      numhl = true,      -- Toggle with `:Gitsigns toggle_numhl`
      sign_priority = 10,
      count_chars = {
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
      },
      on_attach = function(bufnr)
        if vim.fn.expand("%:t") == "lsp.log" or vim.bo.filetype == "help" then
          return false
        end
        local gitlinker = require("gitlinker")
        local gs = package.loaded.gitsigns
        local miniclue = require("mini.clue")
        miniclue.set_mapping_desc("v", "<leader>gc", "Copy GitHub link")
        miniclue.set_mapping_desc("n", "<leader>gc", "Copy GitHub link")

        local function map(lhs, rhs, desc)
          vim.keymap.set("n", lhs, rhs, { desc = desc, buffer = bufnr })
        end

        map("<leader>go", function()
          gitlinker.get_buf_range_url("n", { action_callback = require("gitlinker.actions").open_in_browser })
        end, "Open in browser")

        map("<leader>ghb", function()
          gs.blame_line({ full = true })
        end, "Blame Line")
        map("<leader>ghB", function()
          gs.blame()
        end, "Blame Buffer")
        map("<leader>ghs", gs.stage_hunk, "Stage hunk")
        map("<leader>ghr", gs.reset_hunk, "Reset hunk")
        map("<leader>ghS", gs.stage_buffer, "Stage Buffer")
        map("<leader>ghR", gs.reset_buffer, "Reset buffer")
        map("<leader>ghp", gs.preview_hunk, "Preview hunk")
        map("<leader>ghd", gs.diffthis, "Diff This")
        map("<leader>ghD", function()
          gs.diffthis("~")
        end, "Diff This ~")

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
    "ruifm/gitlinker.nvim",
    lazy = true,
    opts = { mappings = "<leader>gc" },
  },
  {
    "echasnovski/mini-git",
    main = "mini.git",
    config = true,
  },
}
