Config.later(function()
  require("mini.keymap").setup()

  MiniKeymap.map_multistep("i", "<Tab>", { "luasnip_next", "increase_indent", "jump_after_close" })
  MiniKeymap.map_multistep("i", "<S-Tab>", { "luasnip_prev", "decrease_indent", "jump_before_open" })
  MiniKeymap.map_multistep("i", "<CR>", { "blink_accept", "minipairs_cr" })
  MiniKeymap.map_multistep("i", "<BS>", { "minipairs_bs" })

  local notify_many_keys = function(key)
    local lhs = string.rep(key, 5)
    local action = function()
      vim.notify("Too many " .. key)
    end
    MiniKeymap.map_combo({ "n", "x" }, lhs, action)
  end

  notify_many_keys("h")
  notify_many_keys("j")
  notify_many_keys("k")
  notify_many_keys("l")
end)
