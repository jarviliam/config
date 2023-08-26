function _G.dump(...)
	local object = vim.tbl_map(vim.inspect, { ... })
	vim.pretty_print(unpack(object))
end

local M = {}

function M.info(msg)
	vim.cmd("echohl Directory")
	M._echo_multiline(msg)
	vim.cmd("echohl None")
end

function M.warn(msg)
	vim.cmd("echohl WarningMsg")
	M._echo_multiline(msg)
	vim.cmd("echohl None")
end

function M.err(msg)
	vim.cmd("echohl ErrorMsg")
	M._echo_multiline(msg)
	vim.cmd("echohl None")
end

function M.is_darwin()
	return vim.loop.os_uname().sysname == "Darwin"
end
