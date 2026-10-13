local map_split = function(buf_id, lhs, direction)
  local rhs = function()
    local window = MiniFiles.get_explorer_state().target_window

    -- Noop if the explorer isn't open or the cursor is on a directory.
    if window == nil or MiniFiles.get_fs_entry().fs_type == "directory" then
      return
    end
    -- Make new window and set it as target
    local new_target_window
    vim.api.nvim_win_call(MiniFiles.get_explorer_state().target_window or 0, function()
      vim.cmd(direction .. " split")
      new_target_window = vim.api.nvim_get_current_win()
    end)
    MiniFiles.set_target_window(new_target_window)
    -- Go in and close the explorer.
    MiniFiles.go_in({ close_on_file = true })
  end
  local desc = "Split " .. string.sub(direction, 12)
  vim.keymap.set("n", lhs, rhs, { buffer = buf_id, desc = desc })
end

Config.later(function()
  require("mini.files").setup({
    mappings = {
      show_help = "?",
      go_in_plus = "<cr>",
      go_out_plus = "<tab>",
    },
    content = {
      filter = function(entry)
        return entry.fs_type ~= "file" or entry.name ~= ".DS_Store"
      end,
      windows = { width_nofocus = 25 },
      options = { permanent_delete = false },
    },
  })

  Config.minifiles_open_bufdir = function()
    local bufname = vim.api.nvim_buf_get_name(0)
    local path = vim.fn.fnamemodify(bufname, ":p")
    if path and vim.uv.fs_stat(path) then
      MiniFiles.open(bufname, false)
    end
  end

  Config.new_autocmd("User", {
    pattern = "MiniFilesWindowOpen",
    callback = function(args)
      vim.api.nvim_win_set_config(args.data.win_id, { border = "rounded" })
    end,
    desc = "Add rounded corners",
  })

  Config.new_autocmd("User", {
    pattern = "MiniFilesBufferCreate",
    callback = function(args)
      local buffer = args.data.buf_id
      map_split(buffer, "<C-s>", "belowright horizontal")
      map_split(buffer, "<C-v>", "belowright vertical")
    end,
    desc = "Add minifiles split keymaps",
  })

  Config.new_autocmd("User", {
    pattern = { "MiniFilesActionRename", "MiniFilesActionMove" },
    callback = function(args)
      Snacks.rename.on_rename_file(args.data.from, args.data.to)
    end,
    desc = "LSP Rename on File rename",
  })

  Config.new_autocmd("User", {
    pattern = "MiniFilesExplorerOpen",
    callback = function(args)
      MiniFiles.set_bookmark("c", vim.fn.stdpath("config"), { desc = "Config" })
      MiniFiles.set_bookmark("w", vim.fn.getcwd, { desc = "Working Directory" })
    end,
    desc = "Add Mini Bookmarks",
  })
end)

-- vim.keymap.set("n", "<leader>e", function()
-- end, { desc = "File explorer" })
