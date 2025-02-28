return {
  "MagicDuck/grug-far.nvim",
  opts = { headerMaxWidth = 80 },
  cmd = "GrugFar",
  init = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "grug-far",
      callback = function(event)
        vim.b[event.buf].miniclue_config = {
          clues = {
            { mode = "n", keys = "g?", desc = "Help Grug" },
            { mode = "n", keys = "<SPC>r", desc = "Replace Grug" },
            { mode = "n", keys = "<SPC>l", desc = "Sync Line" },
            { mode = "n", keys = "<SPC>s", desc = "Sync All" },
          },
        }
      end,
    })
  end,
  keys = {
    {
      "<leader>s/",
      function()
        local grug = require("grug-far")
        local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
        grug.open({
          transient = true,
          prefills = {
            filesFilter = ext and ext ~= "" and "*." .. ext or nil,
          },
        })
      end,
      mode = { "n", "v" },
      desc = "Search and Replace",
    },
  },
}
