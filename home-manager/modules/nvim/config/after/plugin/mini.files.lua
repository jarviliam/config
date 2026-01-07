local minifiles = require("mini.files")

local map_split = function(buf_id, lhs, direction)
  local rhs = function()
    local window = minifiles.get_explorer_state().target_window

    -- Noop if the explorer isn't open or the cursor is on a directory.
    if window == nil or minifiles.get_fs_entry().fs_type == "directory" then
      return
    end
    -- Make new window and set it as target
    local new_target_window
    vim.api.nvim_win_call(minifiles.get_explorer_state().target_window or 0, function()
      vim.cmd(direction .. " split")
      new_target_window = vim.api.nvim_get_current_win()
    end)
    minifiles.set_target_window(new_target_window)
    -- Go in and close the explorer.
    minifiles.go_in({ close_on_file = true })
  end
  local desc = "Split " .. string.sub(direction, 12)
  vim.keymap.set("n", lhs, rhs, { buffer = buf_id, desc = desc })
end

minifiles.setup({
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

vim.keymap.set("n", "<leader>e", function()
  local bufname = vim.api.nvim_buf_get_name(0)
  local path = vim.fn.fnamemodify(bufname, ":p")
  if path and vim.uv.fs_stat(path) then
    require("mini.files").open(bufname, false)
  end
end, { desc = "File explorer" })

Config.new_autocmd("User", "MiniFilesWindowOpen", function(args)
  vim.api.nvim_win_set_config(args.data.win_id, { border = "rounded" })
end, "Add rounded corners")

Config.new_autocmd("User", "MiniFilesBufferCreate", function(args)
  local buffer = args.data.buf_id
  map_split(buffer, "<C-s>", "belowright horizontal")
  map_split(buffer, "<C-v>", "belowright vertical")
end, "Add minifiles split keymaps")

Config.new_autocmd("User", { "MiniFilesActionRename", "MiniFilesActionMove" }, function(args)
  Snacks.rename.on_rename_file(args.data.from, args.data.to)
end, "LSP Rename on File rename")

Config.new_autocmd("User", "MiniFilesExplorerOpen", function(args)
  minifiles.set_bookmark("c", vim.fn.stdpath("config"), { desc = "Config" })
  minifiles.set_bookmark("w", vim.fn.getcwd, { desc = "Working Directory" })
end, "Add Mini Bookmarks")
