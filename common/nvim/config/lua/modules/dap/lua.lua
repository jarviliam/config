local ok, dap = as.safe_require("dap")
if not ok then
	return
end

dap.configurations.lua = {
	{
		name = "Attach to running Neovim instance",
		type = "nlua",
		request = "attach",
		host = function()
			local value = vim.fn.input("Host [127.0.0.1]: ")
			if value ~= "" then
				return value
			end
			return "127.0.0.1"
		end,
		port = function()
			local val = tonumber(vim.fn.input("Port: "))
			assert(val, "Please provide a port number")
			return val
		end,
	},
}

dap.adapters.nlua = function(callback, config)
	callback({ type = "server", host = config.host, port = config.port })
end
