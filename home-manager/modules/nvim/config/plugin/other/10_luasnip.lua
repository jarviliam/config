Config.later(function()
  vim.pack.add(
    { "https://github.com/L3MON4D3/LuaSnip", "https://github.com/rafamadriz/friendly-snippets" },
    { load = true }
  )

  local luasnip = require("luasnip")
  local types = require("luasnip.util.types")

  luasnip.setup({
    delete_check_events = "TextChanged",
    -- Display a cursor-like placeholder in unvisited nodes
    -- of the snippet.
    ext_opts = {
      [types.insertNode] = {
        unvisited = {
          virt_text = { { "|", "Conceal" } },
          virt_text_pos = "inline",
        },
      },
      [types.exitNode] = {
        unvisited = {
          virt_text = { { "|", "Conceal" } },
          virt_text_pos = "inline",
        },
      },
      [types.choiceNode] = {
        active = {
          virt_text = { { "(snippet) choice node", "LspInlayHint" } },
        },
      },
    },
  })

  -- Load my custom snippets:
  require("luasnip.loaders.from_vscode").lazy_load({})

  -- Use <C-c> to select a choice in a snippet.
  vim.keymap.set({ "i", "s" }, "<C-c>", function()
    if luasnip.choice_active() then
      require("luasnip.extras.select_choice")()
    end
  end, { desc = "Select choice" })
  vim.keymap.set({ "i" }, "<C-r>s", function()
    require("luasnip.extras.otf").on_the_fly("s")
  end, { desc = "Insert on the fly" })
end)
