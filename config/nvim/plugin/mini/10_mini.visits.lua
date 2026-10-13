Config.later(function()
  local mv = require("mini.visits")
  mv.setup({})

  Config.minivisits_pick = function(cwd)
    local fzf_lua = require("fzf-lua")
    -- Register mini.visits extension
    fzf_lua.register_extension(
      "visit_paths", -- name
      function()
        local path = require("fzf-lua.path")
        local paths = require("mini.visits").list_paths()
        -- Convert absolute paths to relative paths
        local relative_paths = {}
        for _, p in ipairs(paths) do
          table.insert(relative_paths, path.relative_to(p, cwd))
        end
        return fzf_lua.fzf_exec(relative_paths, {
          prompt = "Visit Paths> ",
          cwd = cwd,
          cwd_prompt = true, -- Enable cwd in prompt
          cwd_prompt_shorten_len = 32, -- Shorten if longer than 32 chars
          cwd_prompt_shorten_val = 1, -- Length of shortened parts
          previewer = "builtin",
          actions = {
            ["default"] = fzf_lua.actions.file_edit,
            ["ctrl-s"] = fzf_lua.actions.file_split,
            ["ctrl-v"] = fzf_lua.actions.file_vsplit,
          },
        })
      end, -- function
      { prompt = "Visit> " }, -- default options (optional)
      false -- override existing (optional)
    )
  end
end)
