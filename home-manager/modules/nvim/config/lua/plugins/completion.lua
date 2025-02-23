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

              -- Show the snippet if Treesitter bails.
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
      require("luasnip.loaders.from_vscode").lazy_load({
        -- paths = vim.fn.stdpath("config") .. "/codesnippets",
      })

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
  ---@diagnostic disable: missing-fields
  {
    "saghen/blink.cmp",
    lazy = false,
    dev = true,
    enabled = vim.g._blink,
    dependencies = {
      { "fang2hou/blink-copilot" },
    },
    version = "*",
    ---@module "blink.cmp"
    ---@type blink.cmp.Config
    opts = {
      cmdline = {
        enabled = true,
        keymap = {
          preset = "super-tab",
        },
        sources = function()
          -- Search forward and backward
          if type == "/" or type == "?" then
            return {}
          end
          -- Commands
          if type == ":" or type == "@" then
            return { "cmdline" }
          end
          return {}
        end,
      },
      sources = {
        default = { "lsp", "snippets", "copilot", "path", "buffer" },
        per_filetype = {
          codecompanion = { "codecompanion" },
          lua = {
            "lazydev",
            "lsp",
            "path",
            "snippets",
            "copilot",
          },
        },
        providers = {
          snippets = {
            -- don't show when triggered manually (= length ), useful
            -- when manually show completions to see available JSON keys
            min_keyword_length = 1,
          },
          path = {
            opts = {
              get_cwd = vim.uv.cwd,
            },
          },
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            fallbacks = { "lsp" },
          },
          codecompanion = {
            name = "CodeCompanion",
            module = "codecompanion.providers.completion.blink",
            enabled = true,
          },
          buffer = {
            max_items = 4,
            min_keyword_length = 4,
            score_offset = -3,

            -- show completions from all buffers used within the last x minutes
            opts = {
              get_bufnrs = function()
                local mins = 15
                local allOpenBuffers = vim.fn.getbufinfo({ buflisted = 1, bufloaded = 1 })
                local recentBufs = vim
                  .iter(allOpenBuffers)
                  :filter(function(buf)
                    local recentlyUsed = os.time() - buf.lastused < (60 * mins)
                    local nonSpecial = vim.bo[buf.bufnr].buftype == ""
                    return recentlyUsed and nonSpecial
                  end)
                  :map(function(buf)
                    return buf.bufnr
                  end)
                  :totable()
                return recentBufs
              end,
            },
          },
          copilot = {
            name = "copilot",
            module = "blink-copilot",
            score_offset = 100,
            async = true,
          },
        },
      },
      snippets = {
        preset = "luasnip",
      },
      keymap = {
        preset = "super-tab",
      },
      completion = {
        list = {
          cycle = { from_top = false }, -- cycle at bottom, but not at the top
          selection = {
            auto_insert = false,
            preselect = false,
          },
        },
        accept = {
          auto_brackets = { enabled = true }, -- experimental
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 100,
          window = {
            border = ui.border.name,
          },
        },
        menu = {
          draw = {
            treesitter = { "lsp", "copilot" },
            columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind", gap = 1 } },
            components = {
              kind_icon = {
                ellipsis = false,
                text = function(ctx)
                  return select(1, require("mini.icons").get("lsp", ctx.kind))
                end,
                highlight = function(ctx)
                  return select(2, require("mini.icons").get("lsp", ctx.kind))
                end,
              },

              kind = {
                ellipsis = false,
                width = { fill = true },
              },

              label = {
                width = { fill = true, max = 60 },
              },

              label_description = {
                width = { max = 30 },
              },

              source_name = {
                width = { max = 30 },
              },
            },
          },
        },
      },
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "mono",
      },
    },
  },
}
