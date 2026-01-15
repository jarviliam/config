Config.later(function()
  vim.pack.add({
    "https://github.com/folke/flash.nvim",
  }, { load = true })

  local fl = require("flash")
  fl.setup({
    jump = { nohlsearch = true },
    prompt = {
      -- Place the prompt above the statusline.
      win_config = { row = -3 },
    },
    search = {
      exclude = {
        "flash_prompt",
        "qf",
        function(win)
          return not vim.api.nvim_win_get_config(win).focusable
        end,
      },
    },
    modes = {
      -- Enable flash when searching with ? or /
      search = { enabled = true },
    },
  })

  vim.keymap.set({ "n", "x", "o" }, "s", fl.jump, { desc = "Flash" })
  vim.keymap.set({ "o" }, "r", fl.treesitter_search, { desc = "Treesitter Search" })
  vim.keymap.set({ "o" }, "R", fl.remote, { desc = "Remote Flash" })
end)
