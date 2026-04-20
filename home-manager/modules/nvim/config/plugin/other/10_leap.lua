Config.later(function()
  vim.pack.add({ "https://codeberg.org/andyg/leap.nvim" })

  require("leap").opts.equivalence_classes = { " \t\r\n", "([{", ")]}", "'\"`" }
  require("leap").opts.preview = function(ch0, ch1, ch2)
    return not (ch1:match("%s") or (ch0:match("%a") and ch1:match("%a") and ch2:match("%a")))
  end

  Config.leap = {}
  Config.leap.treesitter_select = function()
    require("leap.treesitter").select({
      -- To increase/decrease the selection in a clever-f-like manner,
      -- with the trigger key itself (vRRRRrr...).
      opts = require("leap.user").with_traversal_keys("R", "r"),
    })
  end
  Config.leap.remote = function()
    -- Automatically enter Visual mode when coming from Normal.
    require("leap.remote").action({
      -- Automatically enter Visual mode when coming from Normal.
      input = vim.fn.mode(true):match("o") and "" or "v",
    })
  end

  vim.api.nvim_create_autocmd("User", {
    pattern = "RemoteOperationDone",
    group = vim.api.nvim_create_augroup("LeapRemote", {}),
    callback = function(event)
      -- Do not paste if some special register was in use.
      if vim.v.operator == "y" and event.data.register == '"' then
        vim.cmd("normal! p")
      end
    end,
  })

  for _, ai in ipairs({ "a", "i" }) do
    vim.keymap.set({ "x", "o" }, ai .. "r", function()
      -- A trick to avoid having to create separate mappings for each text
      -- object: when entering `ar`/`ir`, consume the next character, and
      -- create the input from that character concatenated to `a`/`i`.
      local ok, ch = pcall(vim.fn.getcharstr) -- pcall for handling <C-c>
      if not ok or (ch == vim.keycode("<esc>")) then
        return
      end
      require("leap.remote").action({ input = ai .. ch })
    end)
  end
end)
