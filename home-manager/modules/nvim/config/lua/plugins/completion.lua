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
        -- Check if the current snippet was deleted.
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
        },
        snip_env = {
          -- Helper function for showing a snippet if the Treesitter node
          -- satisfies a given predicate.
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
    version = "*",
    dependencies = { "L3MON4D3/LuaSnip" },
    ---@module "blink.cmp"
    ---@type blink.cmp.Config
    opts = {
      sources = {
        default = { "lazydev", "lsp", "path", "luasnip", "buffer" },
        providers = {
          snippets = {
            -- don't show when triggered manually (= length 0), useful
            -- when manually show completions to see available JSON keys
            min_keyword_length = 1,
            expand = function(snippet)
              require("luasnip").lsp_expand(snippet)
            end,
            active = function(filter)
              if filter and filter.direction then
                return require("luasnip").jumpable(filter.direction)
              end
              return require("luasnip").in_snippet()
            end,
            jump = function(direction)
              require("luasnip").jump(direction)
            end,
          },
          path = {
            opts = {
              get_cwd = vim.uv.cwd,
            },
          },
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            fallback = { "lsp" },
          },
          codecompanion = {
            name = "CodeCompanion",
            module = "codecompanion.providers.completion.blink",
            enabled = false,
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
        },
      },
      keymap = {
        preset = "default",
      },
      completion = {
        list = {
          cycle = { from_top = false }, -- cycle at bottom, but not at the top
        },
        accept = {
          auto_brackets = { enabled = true }, -- experimental
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          window = {
            border = ui.border.name,
          },
        },
        menu = {
          draw = {
            treesitter = true,
            columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
            components = {
              kind_icon = {
                ellipsis = false,
                text = function(ctx)
                  return ctx.kind_icon .. ctx.icon_gap
                end,
              },

              kind = {
                ellipsis = false,
                width = { fill = true },
                text = function(ctx)
                  return ctx.kind
                end,
              },

              label = {
                width = { fill = true, max = 60 },
                text = function(ctx)
                  return ctx.label .. ctx.label_detail
                end,
                highlight = function(ctx)
                  -- label and label details
                  local highlights = {
                    { 0, #ctx.label, group = ctx.deprecated and "BlinkCmpLabelDeprecated" or "BlinkCmpLabel" },
                  }
                  if ctx.label_detail then
                    table.insert(
                      highlights,
                      { #ctx.label, #ctx.label + #ctx.label_detail, group = "BlinkCmpLabelDetail" }
                    )
                  end

                  -- characters matched on the label by the fuzzy matcher
                  for _, idx in ipairs(ctx.label_matched_indices) do
                    table.insert(highlights, { idx, idx + 1, group = "BlinkCmpLabelMatch" })
                  end

                  return highlights
                end,
              },

              label_description = {
                width = { max = 30 },
                text = function(ctx)
                  return ctx.label_description
                end,
                highlight = "BlinkCmpLabelDescription",
              },

              source_name = {
                width = { max = 30 },
                text = function(ctx)
                  return ctx.source_name
                end,
                highlight = "BlinkCmpSource",
              },
            },
          },
        },
      },
      appearance = {
        -- supported: tokyonight
        -- not supported: nightfox, gruvbox-material
        use_nvim_cmp_as_default = true,
        kind_icons = ui.icons.symbol_kinds,
      },
    },
  },
}
