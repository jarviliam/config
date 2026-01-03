return {
  "sainnhe/gruvbox-material",
  config = function()
    vim.cmd.colorscheme("gruvbox-material")
  end,
  init = function(spec)
    vim.g.gruvbox_material_enable_bold = 1
    vim.g.gruvbox_material_transparent_background = 0
    vim.g.gruvbox_material_foreground = "material"
    vim.g.gruvbox_material_background = "soft" -- soft, medium, hard
    vim.g.gruvbox_material_ui_contrast = "high" -- The contrast of line numbers, indent lines, etc.
    vim.g.gruvbox_material_statusline_style = "material"
    vim.g.gruvbox_material_diagnostic_virtual_text = "colored"
    vim.g.gruvbox_material_inlay_hints_background = "dimmed"
    vim.g.gruvbox_material_menu_selection_backgrouund = "colored"

    local name = vim.fs.basename(spec[1])
    vim.api.nvim_create_autocmd("ColorScheme", {
      desc = "User Highlights for " .. name,
      pattern = name,
      callback = function()
        local setHl = function(...)
          vim.api.nvim_set_hl(0, ...)
        end
        local hlCmd = vim.cmd.highlight

        setHl("BlinkCmpMenu", { bg = "#32302f" })
        setHl("BlinkCmpMenuBorder", { bg = "#32302f" })
      end,
    })
  end,
  lazy = false,
  priority = 1000,
}
