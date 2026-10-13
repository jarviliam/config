Config.now(function()
  local ms = require("mini.statusline")
  ms.setup({
    use_icons = true,
    content = {
      active = function()
        local mode, mode_hl = ms.section_mode({ trunc_width = 120 })
        local git = ms.section_git({ trunc_width = 40 })
        local diff = ms.section_diff({ trunc_width = 75 })
        local diagnostics = ms.section_diagnostics({ trunc_width = 75 })
        local lsp = ms.section_lsp({ trunc_width = 75 })
        local filename = ms.section_filename({ trunc_width = 140 })
        local fileinfo = ms.section_fileinfo({ trunc_width = 120 })
        local location = ms.section_location({ trunc_width = 75 })
        local search = ms.section_searchcount({ trunc_width = 75 })
        return ms.combine_groups({
          { hl = mode_hl, strings = { mode } },
          { hl = "MiniStatuslineDevinfo", strings = { git, diff, diagnostics, lsp } },
          "%<", -- Mark general truncate point
          { hl = "MiniStatuslineFilename", strings = { filename } },
          "%=", -- End left alignment
          { hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
          { hl = mode_hl, strings = { search, location } },
          -- sl.aerial(),
        })
      end,
    },
  })
end)
