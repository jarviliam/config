local icons = {
	Text = " [Text]",
	Method = " [Method]",
	Function = " [Func]",
	Constructor = " [Constructor]",
	Field = "ﰠ [Field]",
	Variable = " [Var]",
	Class = " [Class]",
	Interface = " [Interface]",
	Module = " [Mod]",
	Property = "ﰠ [Prop]",
	Unit = "塞 [Unit]",
	Value = " [value]",
	Enum = " [Enum]",
	Keyword = " [Key]",
	Snippet = " [Snip]",
	Color = " [color]",
	File = " [File]",
	Reference = " [Ref]",
	Folder = " [Folder]",
	EnumMember = " [Enum Member]",
	Constant = " [Const]",
	Struct = "פּ [Struct]",
	Event = " [Event]",
	Operator = " [Op]",
	TypeParameter = "",
}

for kind, symbol in pairs(icons) do
	local kinds = vim.lsp.protocol.CompletionItemKind
	local index = kinds[kind]

	if index ~= nil then
		kinds[index] = symbol
	end
end
