return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {
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
  },
  keys = {
    {
      "s",
      mode = { "n", "x", "o" },
      function()
        require("flash").jump()
      end,
      desc = "Flash",
    },
    {
      "r",
      mode = "o",
      function()
        require("flash").treesitter_search()
      end,
      desc = "Treesitter Search",
    },
    {
      "R",
      mode = "o",
      function()
        require("flash").remote()
      end,
      desc = "Remote Flash",
    },
  },
}
