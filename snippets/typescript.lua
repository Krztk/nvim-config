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

ls.add_snippets("typescript", {
	s(
		"us",
		fmt("const [{}, {}] = useState<{}>({});{}", {
			i(1),
			d(2, function(args)
				print(args)
				print(args[1])
				local name = args[1][1]
				if name ~= nil and #name > 0 then
					name = "set" .. string.sub(name, 1, 1):upper() .. string.sub(name, 2)
				else
					name = ""
				end

				return sn(nil, {
					i(1, name),
				})
			end, { 1 }),
			i(3),
			i(4),
			i(0),
		})
	),
	s("cl", fmt("console.log({});{}", { i(1), i(0) })),
})
