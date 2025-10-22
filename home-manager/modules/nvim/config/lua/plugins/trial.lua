---@type LazySpec[]
return {
  {
    "rachartier/tiny-code-action.nvim",
    event = "LspAttach",
    opts = {
      picker = { "buffer", opts = { hotkeys = true } },
    },
  },
  {
    "cenk1cenk2/schema-companion.nvim",
    ft = { "helm", "yaml" },
    keys = {
      {
        "<leader>ys",
        function()
          Snacks.notify.info(require("schema-companion").get_current_schemas() or "none")
        end,
        desc = "Show the current schema",
      },
      {
        "<leader>yS",
        function()
          return require("schema-companion").select_schema()
        end,
        desc = "Select a schema",
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
