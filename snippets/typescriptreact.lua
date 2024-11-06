local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local d = ls.dynamic_node
local sn = ls.snippet_node
local extras = require("luasnip.extras")
local rep = extras.rep

local fmt = require("luasnip.extras.fmt").fmt
local t = ls.text_node
local f = ls.function_node

local function to_title_case(str)
	return string.sub(str, 1, 1):upper() .. string.sub(str, 2):lower()
end

local function split_string(str)
	local result = {}
	local part = ""

	for index = 1, #str do
		local char = str:sub(index, index)
		local next_char = str:sub(index + 1, index + 1)

		part = part .. char

		if char == "-" then
			table.insert(result, part:sub(1, -2))
			part = ""
		elseif next_char ~= "" and char:match("%l") and next_char:match("%u") then
			table.insert(result, part)
			part = ""
		end
	end

	if part ~= "" then
		table.insert(result, part)
	end

	return result
end

local function to_pascal_case(strArray)
	local parts = vim.tbl_map(to_title_case, strArray)
	return table.concat(parts, "")
end

local function suggest_filename(fname, dname)
	local nameCandidate = fname
	if fname == "index" then
		local normalized = vim.fn.substitute(dname, "\\", "/", "g")
		local parentFolder = vim.fn.matchstr(normalized, [[\([^/]*\)$]])
		nameCandidate = parentFolder
	end

	local parts = split_string(nameCandidate)
	return to_pascal_case(parts)
end

ls.add_snippets("typescriptreact", {
	s("di", fmt("<div>{}</div>", { i(0) })),
	s('di"', fmt('<div className="{}">{}</div>', { i(1), i(0) })),
	s("di{", fmt("<div className={{{}}}>{}</div>", { i(1), i(0) })),
	s("tg", fmt("<{}>{}</{}>", { i(1), i(0), rep(1) })),
	s('tg"', fmt('<{} className="{}">{}</{}>', { i(1), i(2), i(0), rep(1) })),
	s("tg{", fmt("<{} className={{{}}}>{}</{}>", { i(1), i(2), i(0), rep(1) })),
	s("cn", fmt('className="{}"{}', { i(1), i(0) })),
	s(
		"rsf",
		fmt(
			[[
	export const {} = () => {{

	  return (
	    {}
	  )
	}}
	  ]],
			{
				d(1, function(_, snip)
					return sn(1, {
						i(1, suggest_filename(snip.env.TM_FILENAME_BASE, snip.env.TM_DIRECTORY)),
					})
				end, {}),
				i(0),
			}
		)
	),
	s(
		"rsfp",
		fmt(
			[[
  interface Props {{
    {}
  }}

	export const {} = ({}: Props) => {{

	  return (
	    {}
	  )
	}}
	  ]],
			{
				i(1),
				d(2, function(_, snip)
					return sn(nil, {
						i(1, suggest_filename(snip.env.TM_FILENAME_BASE, snip.env.TM_DIRECTORY)),
					})
				end, {}),
				i(3, "props"),
				i(0),
			}
		)
	),
	s("pro", fmt("{{{}}} : {}", { i(2), i(1, "Props") })),
	-- tailwindcss
	s("fcb", fmt("flex items-center justify-between", {})),
})

ls.filetype_extend("typescriptreact", { "typescript" })
