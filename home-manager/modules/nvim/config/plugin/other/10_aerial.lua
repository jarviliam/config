Config.later(function()
  vim.pack.add({ "https://github.com/jarviliam/aerial.nvim" }, {
    load = true,
  })

  require("aerial").setup({
    attach_mode = "global",
    backends = { "lsp", "treesitter", "markdown", "man" },
    layout = {
      max_width = { 80, 0.2 },
      default_direction = "prefer_left",
    },
    show_guides = true,
    filter_kind = false,
    guides = {
      mid_item = "├ ",
      last_item = "└ ",
      nested_top = "│ ",
      whitespace = "  ",
    },
    keymaps = {
      ["[y"] = "actions.prev",
      ["]y"] = "actions.next",
      ["[Y"] = "actions.prev_up",
      ["]Y"] = "actions.next_up",
      ["{"] = false,
      ["}"] = false,
      ["[["] = false,
      ["]]"] = false,
    },

    get_highlight = function(symbol, is_icon, is_collapsed)
      local kind_map = Config._cachedSymbols
      if kind_map == nil then
        return nil
      end
      local kind = kind_map[symbol.kind]
      -- If the symbol has a non-public scope, use that as the highlight group (e.g. AerialPrivate)
      if symbol.scope and not is_icon and symbol.scope ~= "public" then
        return string.format("Aerial%s", symbol.scope:gsub("^%l", string.upper))
      end

      local out = string.format("Aerial%s%s", kind, is_icon and "Icon" or "")
      return out
    end,
    custom_icon_provider = function(kind)
      local kind_map = Config._cachedSymbols
      if kind_map == nil then
        return ""
      end
      return MiniIcons.get("lsp", kind_map[kind])
    end,
    on_attach = function(bufnr)
      vim.keymap.set("n", "]y", function()
        require("aerial").next(vim.v.count1)
      end, { desc = "Next symbol", buffer = bufnr })
      vim.keymap.set("n", "[y", function()
        require("aerial").prev(vim.v.count1)
      end, { desc = "Next symbol", buffer = bufnr })
      vim.keymap.set("n", "]Y", function()
        require("aerial").next_up(vim.v.count1)
      end, { desc = "Next symbol", buffer = bufnr })
      vim.keymap.set("n", "[Y", function()
        require("aerial").prev_up(vim.v.count1)
      end, { desc = "Next symbol", buffer = bufnr })
    end,
  })
end)
