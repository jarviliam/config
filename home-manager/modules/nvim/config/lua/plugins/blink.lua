return {
  {
    "saghen/blink.cmp",
    events = { "InsertEnter" },
    dev = true,
    version = "*",
    opts = {
      cmdline = {
        keymap = {
          preset = "cmdline",
        },
      },
      sources = {
        default = function()
          local default = { "lsp", "buffer" }
          local ok, node = pcall(vim.treesitter.get_node)
          if ok and node then
            if not vim.tbl_contains({ "comment", "line_comment", "block_comment" }, node:type()) then
              table.insert(default, "path")
            end
            if node:type() ~= "string" then
              table.insert(default, "snippets")
            end
          end
          return default
        end,
        per_filetype = {
          codecompanion = { "codecompanion" },
          gitcommit = { "conventional_commits", "git" },
          lua = {
            "lazydev",
            "lsp",
            "path",
            "snippets",
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
            score_offset = 100,
          },
          conventional_commits = {
            name = "Conventional Commits",
            module = "blink-cmp-conventional-commits",
            enabled = function()
              return vim.bo.filetype == "gitcommit"
            end,
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
          auto_brackets = { enabled = true },
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
                highlight = function(ctx)
                  return select(2, require("mini.icons").get("lsp", ctx.kind))
                end,
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
  { "fang2hou/blink-copilot" },
  { "Kaiser-Yang/blink-cmp-git" },
  { "disrupted/blink-cmp-conventional-commits" },
}
