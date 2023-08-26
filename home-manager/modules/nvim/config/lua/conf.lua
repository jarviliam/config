local M = {}

-- Theme selector
M.theme = "sonokai"
-- Toggle Global Statusline
M.global_statusline = false

if M.theme == "sonokai" or M.theme == "edge" or M.theme == "everforest" then
	vim.g.sonokai_style = "atlantis"
	vim.g.sonokai_enable_italic = 1
	vim.g.sonokai_disable_italic_comment = 1
	vim.g.sonokai_cursor = "blue"
	vim.g.sonokai_lightline_disable_bold = 1
	vim.g.sonokai_diagnostic_text_highlight = 1
	vim.g.sonokai_diagnostic_virtual_text = "colored"
	vim.g.sonokai_better_performance = 1
	vim.cmd("set background=dark")

	vim.g.everforest_background = "medium"
	vim.g.everforest_enable_italic = 1
	vim.g.everforest_diagnostic_text_highlight = 1
	vim.g.everforest_diagnostic_virtual_text = "colored"
	vim.g.edge_style = "aura"
	vim.g.edge_better_performance = 1
	vim.g.edge_diagnostic_text_highlight = 1
	vim.g.edge_diagnostic_virtual_text = "colored"
end

return M
