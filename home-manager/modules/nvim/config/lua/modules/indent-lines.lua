local ok, indent = as.safe_require("indent_blankline")
if not ok then
	return
end
indent.setup({
	char = "|",
	context_char = "┃",
	use_treesitter = true,
	show_first_indent_level = false,
	filetype_exclude = { "help", "markdown", "packer", "lspinfo", "checkhealth", "txt" },
	space_char = "·",
	buftype_exclude = {
		"terminal",
		"help",
		"vimwiki",
		"startify",
		"man",
		"git",
		"packer",
		"gitmessengerpopup",
		"diagnosticpopup",
		"markdown",
		"lspinfo",
	},
	show_current_context = true,
})
