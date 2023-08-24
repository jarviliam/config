return {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
       "hrsh7th/cmp-nvim-lsp",
       "hrsh7th/cmp-path",
       "hrsh7th/cmp-buffer",
       "hrsh7th/cmp-nvim-lua",
       "hrsh7th/cmp-nvim-lua",
       "saadparwaiz1/cmp_luasnip",
       "petertriho/cmp-git",
    },
    config = function ()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    local compare = require("cmp.config.compare")
-- Add parens to functions returned from cmp
    cmp.event:on(
      'confirm_done',
      require('nvim-autopairs.completion.cmp').on_confirm_done(
        {
          filetypes = {
            ["*"] = {
              ["("] = {
                kind = {
                  cmp.lsp.CompletionItemKind.Function,
                  cmp.lsp.CompletionItemKind.Method,
                },
                handler = require('nvim-autopairs.completion.handlers')["*"]
              }
            },
          }
        }
      )
    )

cmp.setup({
      window = {
        documentation = cmp.config.window.bordered(),
        completion = {
          winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
          col_offset = -4,
          side_padding = 0,
        },
      },
      formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, item)
      item.kind = as.style.lsp.kind[item.kind]
      item.menu = ({
        nvim_lsp = "[LSP]",
        nvim_lua = "[Api]",
        luasnip = "[Snip]",
        buffer = "[Buffer]",
        path = "[Path]",
        git = "[Git]",
      })[entry.source.name]
          return item
        end,
      },

      sorting = {
        priority_weight = 2,
        comparators = {
          compare.score,
          compare.exact,
          compare.recently_used,
          compare.offset,
          compare.kind,
          compare.sort_text,
          compare.length,
          compare.order,
        },
      },

      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },

  mapping = cmp.mapping.preset.insert({
    ["<C-e>"] = cmp.config.disable,
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-y>"] = cmp.mapping(
      cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Insert,
        select = true,
      }),
      { "i", "c" }
    ),
    }),
  sources = cmp.config.sources({
    { name = "luasnip",  priority_weight = 80 },
    { name = "nvim_lsp", priority_weight = 100, max_item_count = 15 },
    { name = "nvim_lua", priority_weight = 90 },
    { name = "buffer",   priority_weight = 70,  max_item_count = 5 },
    { name = "path",     priority_weight = 110, keyword_length = 3 },
    { name = "git" },
  }),
  experimental = {
    ghost_text = true,
  }
})
require("cmp_git").setup()
    end
}
