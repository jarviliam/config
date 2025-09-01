return {
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    keys = {
      {
        "<C-r>s",
        function()
          require("luasnip.extras.otf").on_the_fly("s")
        end,
        desc = "Insert on-the-fly snippet",
        mode = "i",
      },
    },
    opts = function()
      local types = require("luasnip.util.types")
      return {
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
      }
    end,
    config = function(_, opts)
      local luasnip = require("luasnip")

      luasnip.setup(opts)

      -- Load my custom snippets:
      require("luasnip.loaders.from_vscode").lazy_load({})

      -- Use <C-c> to select a choice in a snippet.
      vim.keymap.set({ "i", "s" }, "<C-c>", function()
        if luasnip.choice_active() then
          require("luasnip.extras.select_choice")()
        end
      end, { desc = "Select choice" })
    end,
  },
}
