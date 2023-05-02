local map = vim.keymap.set
local M = {}

M.setup = function()
	local ok, dap = as.safe_require("dap")
	if not ok then
		return
	end
	local lang = {
		"cpp",
		"go",
		"go_test",
		"python",
		"node",
		"lua",
	}
	for _, l in pairs(lang) do
		local fname = string.format("modules.dap.%s", l)
		as.safe_require(fname)
	end

	local _, dapui = as.safe_require("dapui")

	map(
		"n",
		"<Space>d~",
		dap.toggle_breakpoint,
		{ desc = "dap: Toggle Breakpoint" }
	)
	map(
		"n",
		"<Space>d-",
		"<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>"
	)
	map("n", "<Space>do", dap.continue, { desc = "dap: Continue" })
	map("n", "<Space>df", dapui.toggle, { desc = "dapui: Toggle" })
	dap.listeners.after.event_stopped["jarviliam"] = function()
		map("n", "<leader>dh", "<cmd>lua require 'dap.ui.widgets'.hover()<CR>")
		map(
			"v",
			"<leader>dh",
			"<cmd>lua require 'dap.ui.widgets'.visual_hover()<CR>"
		)
		map("n", "<leader>dj", dap.step_into, { desc = "dap: Step Into" })
		map("n", "<leader>dl", dap.step_over, { desc = "dap: Step Over" })
		map("n", "<leader>dk", dap.step_out, { desc = "dap: Step Out" })
		map("n", "<leader>dr", dap.restart, { desc = "dap: Restart" })
		map("n", "<leader>dn", dap.run_to_cursor, { desc = "dap: Run To Cursor" })
	end
	dap.listeners.before.event_exited["jarviliam"] = function()
		vim.keymap.del({ "n", "v" }, "<leader>dh")
		vim.keymap.del("n", "<leader>dj")
		vim.keymap.del("n", "<leader>dl")
		vim.keymap.del("n", "<leader>dk")
		vim.keymap.del("n", "<leader>dr")
		vim.keymap.del("n", "<leader>dn")
		dapui.close()
	end
	dap.listeners.before.event_terminated["dapui_config"] = function()
		dapui.close()
	end
end

return M
