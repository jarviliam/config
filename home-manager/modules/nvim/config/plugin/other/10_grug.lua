Config.later(function()
  vim.pack.add({
    "https://github.com/MagicDuck/grug-far.nvim",
  }, { load = true })

  local gf = require("grug-far")

  gf.setup({
    headerMaxWidth = 80,
  })

  Config.new_autocmd("FileType", {
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

  Config.new_cmd("GrugFarWord", function()
    gf.open({ prefills = { search = vim.fn.expand("<cword>") } })
  end, { desc = "Search and Replace word under cursor" })

  Config.grug_search = function()
    local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
    gf.open({
      transient = true,
      prefills = {
        filesFilter = ext and ext ~= "" and "*." .. ext or nil,
      },
    })
  end
end)
