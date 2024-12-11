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
  {
    "iguanacucumber/magazine.nvim",
    name = "nvim-cmp",
    enabled = not vim.g._native_compl and not vim.g._blink,
    dependencies = {
      { "L3MON4D3/LuaSnip" },
      { "iguanacucumber/mag-nvim-lsp", name = "cmp-nvim-lsp", opts = {} },
      { "iguanacucumber/mag-buffer", name = "cmp-buffer" },
      { "https://codeberg.org/FelipeLema/cmp-async-path", name = "async_path" },
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
    },
    version = false,
    event = "InsertEnter",
    opts = function()
      local cmp = require("cmp")
      local defaults = require("cmp.config.default")()
      local luasnip = require("luasnip")
      local symbol_kinds = require("icons").symbol_kinds

      local winhighlight = "Normal:Normal,FloatBorder:Normal,CursorLine:Visual,Search:None"

      return {
        preselect = cmp.PreselectMode.None,
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = function(_, vim_item)
            local MAX_ABBR_WIDTH, MAX_MENU_WIDTH = 25, 30
            local ellipsis = require("icons").misc.ellipsis

            -- Add the icon (if given a kind).
            if vim_item.kind then
              vim_item.kind = symbol_kinds[vim_item.kind] .. " " .. vim_item.kind
            end

            -- Truncate the label.
            if vim.api.nvim_strwidth(vim_item.abbr) > MAX_ABBR_WIDTH then
              vim_item.abbr = vim.fn.strcharpart(vim_item.abbr, 0, MAX_ABBR_WIDTH) .. ellipsis
            end

            -- Truncate the description part.
            if vim.api.nvim_strwidth(vim_item.menu or "") > MAX_MENU_WIDTH then
              vim_item.menu = vim.fn.strcharpart(vim_item.menu, 0, MAX_MENU_WIDTH) .. ellipsis
            end

            return vim_item
          end,
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion = {
            border = "rounded",
            winhighlight = winhighlight,
            scrollbar = true,
          },
          documentation = {
            border = "rounded",
            winhighlight = winhighlight,
            max_height = math.floor(vim.o.lines * 0.5),
            max_width = math.floor(vim.o.columns * 0.4),
          },
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-u>"] = cmp.mapping.complete({
            config = {
              sources = { { name = "async_path" } },
            },
          }),
          ["<C-y>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
          }),
          ["/"] = cmp.mapping.close(),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          -- keyword_length = 2 to not show completions with single letter identifiers.
          { name = "nvim_lsp", keyword_length = 2 },
          {
            name = "luasnip",
            -- Don't show snippet completions in comments or strings.
            entry_filter = function()
              local ctx = require("cmp.config.context")
              local in_string = ctx.in_syntax_group("String") or ctx.in_treesitter_capture("string")
              local in_comment = ctx.in_syntax_group("Comment") or ctx.in_treesitter_capture("comment")

              return not in_string and not in_comment
            end,
          },
        }, {
          {
            name = "buffer",
            keyword_length = 3,
            option = {
              -- Buffer completions from all visible buffers (that aren't huge).
              get_bufnrs = function()
                local bufs = {}

                for _, win in ipairs(vim.api.nvim_list_wins()) do
                  local buf = vim.api.nvim_win_get_buf(win)
                  if vim.bo[buf].filetype ~= "bigfile" then
                    table.insert(bufs, buf)
                  end
                end

                return bufs
              end,
            },
          },
        }),
        sorting = defaults.sorting,
        performance = {
          max_view_entries = 10,
        },
      }
    end,
    config = function(_, opts)
      local cmp = require("cmp")

      -- Override the documentation handler to remove the redundant detail section.
      ---@diagnostic disable-next-line: duplicate-set-field
      require("cmp.entry").get_documentation = function(self)
        local item = self.completion_item

        if item.documentation then
          return vim.lsp.util.convert_input_to_markdown_lines(item.documentation)
        end

        -- Use the item's detail as a fallback if there's no documentation.
        if item.detail then
          local ft = self.context.filetype
          local dot_index = string.find(ft, "%.")
          if dot_index ~= nil then
            ft = string.sub(ft, 0, dot_index - 1)
          end
          return (vim.split(("```%s\n%s```"):format(ft, vim.trim(item.detail)), "\n"))
        end

        return {}
      end
      -- Inside a snippet, use backspace to remove the placeholder.
      vim.keymap.set("s", "<BS>", "<C-O>s")

      cmp.setup(opts)
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
