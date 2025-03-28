return {
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
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
        },
        snip_env = {
          ts_show = function(pred)
            return function()
              local row, col = unpack(vim.api.nvim_win_get_cursor(0))
              local ok, node = pcall(vim.treesitter.get_node, { pos = { row - 1, col - 1 } })
              if not ok or not node then
                return true
              end

              return pred(node:type())
            end
          end,
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

      vim.api.nvim_create_autocmd("ModeChanged", {
        group = vim.api.nvim_create_augroup("unlink_snippet", { clear = true }),
        desc = "Cancel the snippet session when leaving insert mode",
        pattern = { "s:n", "i:*" },
        callback = function(args)
          if
            luasnip.session
            and luasnip.session.current_nodes[args.buf]
            and not luasnip.session.jump_active
            and not luasnip.choice_active()
          then
            luasnip.unlink_current()
          end
        end,
      })
    end,
  },
}
