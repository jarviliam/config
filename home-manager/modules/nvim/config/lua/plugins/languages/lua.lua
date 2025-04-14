---@type LazySpec[]
return {
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        { path = "snacks.nvim", words = { "Snacks", "snacks" } },
        { path = "blink.nvim", words = { "blink" } },
        { path = "lazy.nvim", words = { "LazyConfig", "LazySpec", "package" } },
      },
    },
    dependencies = {
      { "LuaCATS/luassert", name = "luassert-types" },
      { "LuaCATS/busted", name = "busted-types" },
      { "Bilal2453/luvit-meta" },
    },
  },
}
