vim.keymap.set(
  { "n", "v" },
  "<leader>gcl",
  "<cmd>GitLink<cr>",
  { silent = true, noremap = true, desc = "Yank git permlink" }
)
vim.keymap.set(
  { "n", "v" },
  "<leader>gcL",
  "<cmd>GitLink!<cr>",
  { silent = true, noremap = true, desc = "Open git permlink" }
)
-- blame
vim.keymap.set(
  { "n", "v" },
  "<leader>gcb",
  "<cmd>GitLink blame<cr>",
  { silent = true, noremap = true, desc = "Yank git blame link" }
)
vim.keymap.set(
  { "n", "v" },
  "<leader>gcB",
  "<cmd>GitLink! blame<cr>",
  { silent = true, noremap = true, desc = "Open git blame link" }
)
-- default branch
vim.keymap.set(
  { "n", "v" },
  "<leader>gcd",
  "<cmd>GitLink default_branch<cr>",
  { silent = true, noremap = true, desc = "Copy default branch link" }
)
vim.keymap.set(
  { "n", "v" },
  "<leader>gcD",
  "<cmd>GitLink! default_branch<cr>",
  { silent = true, noremap = true, desc = "Open default branch link" }
)
-- default branch
vim.keymap.set(
  { "n", "v" },
  "<leader>gcc",
  "<cmd>GitLink current_branch<cr>",
  { silent = true, noremap = true, desc = "Copy current branch link" }
)
vim.keymap.set(
  { "n", "v" },
  "<leader>gcD",
  "<cmd>GitLink! current_branch<cr>",
  { silent = true, noremap = true, desc = "Open current branch link" }
)

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
      numhl = true, -- Toggle with `:Gitsigns toggle_numhl`
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
        local gs = package.loaded.gitsigns

        local function map(lhs, rhs, desc)
          vim.keymap.set("n", lhs, rhs, { desc = desc, buffer = bufnr })
        end

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
    "linrongbin16/gitlinker.nvim",
    lazy = false,
    config = function()
      require("gitlinker").setup()
    end,
  },
}
