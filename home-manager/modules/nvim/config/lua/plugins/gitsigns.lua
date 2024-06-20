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
      numhl = true,    -- Toggle with `:Gitsigns toggle_numhl`
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

        local function map(lhs,rhs,desc)
          vim.keymap.set('n',lhs,rhs,{desc=desc,buffer=bufnr})
        end

        map('<leader>go', function()
          gitlinker.get_buf_range_url('n', { action_callback = require('gitlinker.actions').open_in_browser })
        end, 'Open in browser')
        map("<leader>gb", gs.blame_line, "Blame line" )
        map("<leader>gs", gs.stage_hunk, "Stage hunk" )
        map("<leader>gr", gs.reset_hunk, "Reset hunk" )
        map("<leader>gR", gs.reset_buffer, "Reset buffer" )
        map("<leader>gp", gs.preview_hunk, "Preview hunk" )
        map("]g", gs.next_hunk, "Next hunk" )
        map("[g", gs.prev_hunk, "Prev hunk" )
                map('<leader>gl', function()
                    require('float').float_term('lazygit', {
                        size = { width = 0.85, height = 0.8 },
                        cwd = vim.b.gitsigns_status_dict.root,
                    })
                end, 'Lazygit')
      end,
    },
  },
  {
    'ruifm/gitlinker.nvim',
    lazy = true,
    opts = { mappings = '<leader>gc' },
  },
  {
        'echasnovski/mini-git',
        main = 'mini.git',
        config = true,
        lazy = false,
        keys = {
            {
                '<leader>gd',
                function()
                    require('mini.git').show_at_cursor {}
                end,
                desc = 'Show info at cursor',
                mode = { 'n', 'x' },
            },
        },
    },
}
