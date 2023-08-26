local M = {}

function M.setup()
	-- Automatically update diagnostics
	vim.diagnostic.config({
		virtual_text = { spacing = 4, prefix = "●" },
		signs = true,
		underline = true,
		update_in_insert = false,
		severity_sort = true,
		float = {
			focusable = false,
			style = "minimal",
			border = "rounded",
			source = "always",
			header = "",
			prefix = "",
		},
	})

	for type, icon in pairs(as.style.lsp.signs) do
		local hl = "DiagnosticSign" .. type
		local col = "Diagnostic" .. type
		vim.fn.sign_define(hl, { text = icon, texthl = col })
	end
	vim.cmd([[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float({focusable=false})]])
end

return M
