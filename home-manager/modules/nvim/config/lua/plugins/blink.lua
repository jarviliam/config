---@type LazySpec[]
return {
  {
    "saghen/blink.cmp",
    build = "nix run --accept-flake-config .#build-plugin",
    events = { "InsertEnter" },
    ---@type blink.cmp.Config
    opts = {
      cmdline = {
        keymap = {
          preset = "cmdline",
        },
      },
      snippets = {
        preset = "luasnip",
      },
      keymap = {
        preset = "default",
        ["<CR>"] = { "accept", "fallback" },
        ["<C-q>"] = { "hide", "fallback" },
        ["<C-n>"] = { "select_next", "show" },
        ["<Tab>"] = { "snippet_forward", "fallback" },
        ["<C-p>"] = { "select_prev" },
        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },
      },
      completion = {
        list = {
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
        },
        ---@type blink.cmp.CompletionMenuConfig
        menu = {
          scrollbar = false,
          ---@type blink.cmp.Draw
          draw = {
            treesitter = { "lsp" },
            align_to = "cursor",
            columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind", gap = 1 } },
            components = {
              kind_icon = {
                text = function(ctx)
                  return select(1, require("mini.icons").get("lsp", ctx.kind))
                end,
                highlight = function(ctx)
                  return select(2, require("mini.icons").get("lsp", ctx.kind))
                end,
              },
              kind = {
                highlight = function(ctx)
                  return select(2, require("mini.icons").get("lsp", ctx.kind))
                end,
              },
              label = {
                ---@param ctx blink.cmp.DrawItemContext
                highlight = function(ctx)
                  return require("colorful-menu").blink_components_highlight(ctx)
                end,
                ---@param ctx blink.cmp.DrawItemContext
                text = function(ctx)
                  return require("colorful-menu").blink_components_text(ctx)
                end,
                width = { fill = false },
              },
            },
          },
        },
      },
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "mono",
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
          gitcommit = { "git", "conventional_commits", "dictionary" },
          lua = {
            "lazydev",
            "lsp",
            "path",
            "snippets",
          },
          txt = {
            "dictionary",
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
          git = {
            module = "blink-cmp-git",
            name = "Git",
            opts = {
              before_reload_cache = function() end, -- silence cache-reload notification
              commit = { enable = false },
              git_centers = {
                github = {
                  pull_request = { enable = false },
                  mention = { enable = false },
                  issue = {
                    get_documentation = function()
                      return ""
                    end,
                  }, -- disable doc window
                },
              },
            },
          },
          dictionary = {
            module = "blink-cmp-dictionary",
            name = "Dict",
            min_keyword_length = 3,
            opts = {},
            should_show_items = function()
              return vim.tbl_contains({ "gitcommit", "markdown", "txt" }, vim.o.filetype)
            end,
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
    },
  },
  { "Kaiser-Yang/blink-cmp-git" },
  { "Kaiser-Yang/blink-cmp-dictionary" },
  { "xzbdmw/colorful-menu.nvim" },
  { "disrupted/blink-cmp-conventional-commits" },
}
