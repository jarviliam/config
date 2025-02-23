return {
  {
    {
      "github/copilot.vim",
      cmd = "Copilot",
      enabled = false,
      build = ":Copilot auth",
      opts = {
        suggestion = { enabled = false },
        panel = { enabled = false },
        filetypes = {
          markdown = true,
          help = true,
        },
      },
    },
  },
  {
    "zbirenbaum/copilot.lua",
    enabled = true,
    cmd = "Copilot",
    build = ":Copilot auth",
    init = function()
      vim.api.nvim_create_autocmd({ "User" }, {
        pattern = { "BlinkCmpMenuOpen" },
        callback = function()
          require("copilot.suggestion").dismiss()
          vim.b.copilot_suggestion_hidden = true
        end,
      })
      vim.api.nvim_create_autocmd("User", {
        pattern = { "BlinkCmpMenuClose" },
        callback = function()
          vim.b.copilot_suggestion_hidden = false
        end,
      })
    end,
    opts = {
      filetypes = {
        ["*"] = false, -- Disable for all other filetypes and ignore default `filetypes`
        bash = true,
        c = true,
        cpp = true,
        go = true,
        html = true,
        java = true,
        javascript = true,
        just = true,
        lua = true,
        python = true,
        rust = true,
        sh = true,
        typescript = true,
        zsh = true,
        zig = true,
      },
      -- Per: https://github.com/zbirenbaum/copilot-cmp#install
      panel = {
        enabled = false,
        auto_refresh = true,
      },
      suggestion = {
        enabled = false,
        auto_trigger = true,
        keymap = {
          accept = "<C-y>",
          accept_word = false,
          accept_line = false,
          next = "<C-n>",
          prev = "<C-p>",
          dismiss = "<Esc>",
        },
      },
    },
  },
}
