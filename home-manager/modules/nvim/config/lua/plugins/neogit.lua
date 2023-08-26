return {
	"NeogitOrg/neogit",
	cmd = { "Neogit" },
	opts = {
		disable_signs = false,
		disable_context_highlighting = false,
		disable_commit_confirmation = false,
		disable_builtin_notifications = true,
		signs = {
			-- { CLOSED, OPENED }
			section = { ">", "v" },
			item = { ">", "v" },
			hunk = { "", "" },
		},
		integrations = {
			diffview = true,
			telescope = true,
		},
	},
}
