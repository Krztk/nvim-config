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

local function to_pascal_case(str)
	local parts = vim.split(str, "-")
	if #parts <= 1 then
		return str
	end
	parts = vim.tbl_map(to_title_case, parts)
	return table.concat(parts, "")
end

local function suggest_filename(fname, dname)
	if fname == "index" then
		local normalized = vim.fn.substitute(dname, "\\", "/", "g")
		return to_pascal_case(vim.fn.matchstr(normalized, [[\([^/]*\)$]]))
	else
		return to_pascal_case(fname)
	end
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
})

ls.filetype_extend("typescriptreact", { "typescript" })
