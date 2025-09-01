---@type LazySpec[]
return {
  {
    "nvim-neorg/neorg",
    enabled = false,
    lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
    version = "*", -- Pin Neorg to the latest stable release
    config = true,
  },
  {
    "rachartier/tiny-code-action.nvim",
    event = "LspAttach",
    opts = {
      picker = { "buffer", opts = { hotkeys = true } },
    },
  },
  {
    "folke/trouble.nvim",
    cmd = { "Trouble" },
    keys = {
        -- stylua: ignore
        { "<leader>xx", function() require("trouble").toggle({ mode = "diagnostics" }) end, desc = "Trouble" },
    },
    opts = {
      auto_preview = false,
      focus = true,
      modes = {
        lsp_references = {
          params = {
            include_declaration = false,
          },
        },
      },
    },
  },
  {
    "cenk1cenk2/schema-companion.nvim",
    ft = { "helm", "yaml" },
    keys = {
      {
        "<leader>ys",
        function()
          local schemas = require("schema-companion.schema").all()

          if not schemas or #schemas == 0 then
            vim.notify("No schemas available", vim.log.levels.WARN, { title = "Schema Companion" })
            return
          end

          vim.ui.select(schemas, {
            prompt = "Select any available schema",
            format_item = function(item)
              return item.name or item.uri or "<unnamed>"
            end,
          }, function(choice)
            if choice then
              require("schema-companion.context").schema(vim.api.nvim_get_current_buf(), {
                name = choice.name or choice.uri,
                uri = choice.uri,
              })
            end
          end)
        end,
        desc = "Select a YAML Schema",
      },
    },
    opts = {},
  },
  {
    "danobi/prr",
    ft = { "prr" },
    init = function()
      vim.filetype.add({ extension = { name = "prr" } })
    end,
    config = function(plugin)
      vim.opt.rtp:append(plugin.dir .. "/vim")
    end,
  },
}
