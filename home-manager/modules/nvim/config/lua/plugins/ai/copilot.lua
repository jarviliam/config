return {
  {
    "zbirenbaum/copilot.lua",
    enabled = true,
    cmd = "Copilot",
    build = ":Copilot auth",
    opts = {
      copilot_model = "gpt-4o-copilot",
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
        auto_trigger = false,
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
