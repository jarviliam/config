local ls = require("luasnip")
local snippet = ls.snippet
local t = ls.text_node
--local snip_node = ls.snip_node

local function in_comment()
	local query = vim.treesitter.parse_query(vim.bo.filetype, "(comment) @comment")
	local row = vim.fn.line(".") - 1
	local col = vim.fn.col(".")
	local parser = vim.treesitter.get_parser(0)
	local root = parser:parse()[1]:root()
	for _, match in query:iter_matches(root, 0) do
		for _, node in pairs(match) do
			local r1, c1, r2, c2 = node:range()
			if r1 <= row and r2 >= row then
				if (r2 == row and c2 >= col) or (r1 == row and c1 <= col) or (r1 < row and r2 > row) then
					return true
				end
			end
		end
	end
	return false
end

local M = {
	todo = {
		"TODO(jarviliam)",
		snippet("todo", {}),
	},
}

return M
