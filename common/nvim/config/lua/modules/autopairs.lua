local ok, autopairs = as.safe_require("nvim-autopairs")
if not ok then
	return
end

autopairs.setup({
	disable_filetype = { "TelescopePrompt" },
	ignored_next_char = "%w",
	enable_check_bracket_line = true,
	check_ts = true,
})
require("cmp").event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())
