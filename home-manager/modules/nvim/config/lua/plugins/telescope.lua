return 
  {
    "nvim-telescope/telescope.nvim",
    lazy=true,
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },
    config = function ()
  local actions = require("telescope.actions")
  local trouble = require("trouble.providers.telescope")
  require("telescope").setup({
    defaults = {
      prompt_prefix = "❯ ",
      selection_caret = "❯ ",
      selection_strategy = "reset",
      sorting_strategy = "descending",
      scroll_strategy = "cycle",
      color_devicons = true,
      winblend = 0,
      file_ignore_patterns = { "node_modules", ".terraform", "%.jpg", "%.png" },
      layout_strategy = "flex",
      layout_config = {
        width = 0.95,
        height = 0.70,
        prompt_position = "top",

        horizontal = {
          width = 0.9,
          preview_cutoff = 60,
          preview_width = function(_, cols, _)
            if cols > 200 then
              return math.floor(cols * 0.7)
            else
              return math.floor(cols * 0.6)
            end
          end,
        },
        vertical = {
          width = 0.75,
          height = 0.85,
          preview_height = 0.4,
          mirror = true,
        },
        flex = {
          flip_columns = 120,
        },
      },
      mappings = {
        i = {
          ["<esc>"] = actions.close,
          ["<C-v>"] = actions.select_vertical,

          ["<C-k>"] = actions.preview_scrolling_up,
          ["<C-j>"] = actions.preview_scrolling_down,
          ["<C-s>"] = trouble.open_selected_with_trouble,
          ["<C-t>"] = trouble.open_with_trouble,
          ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
          ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          ["<TAB>"] = actions.toggle_selection + actions.move_selection_next,
          ["<Esc>"] = actions.close,
        },
        n = {
          ["<CR>"] = actions.select_default + actions.center,
          ["<C-d>"] = actions.delete_buffer,
          ["<C-v>"] = actions.select_vertical,
          ["<C-s>"] = trouble.open_selected_with_trouble,
          ["<C-t>"] = trouble.open_with_trouble,
          ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
          ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

          ["<C-k>"] = actions.preview_scrolling_up,
          ["<C-j>"] = actions.preview_scrolling_down,

          ["<Esc>"] = actions.close,
        },
      },

      use_less = true,
      borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    },
    pickers = {
      find_files = {
        find_command = {
          "fd",
          "--type",
          "f",
          "--color=never",
          "--hidden",
          "--follow",
          "-E",
          ".git/*",
          "--strip-cwd-prefix",
        },
      },
      buffers = {
        show_all_buffers = true,
        sort_lastused = true,
      },
    },
    extensions = {
      fzf = {
        fuzzy = true,                   -- false will only do exact matching
        override_generic_sorter = true, -- override the generic sorter
        override_file_sorter = true,    -- override the file sorter
        case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
      },
    },
  })
  require("telescope").load_extension("fzf")
    end
}
