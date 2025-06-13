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
		fmt("const [{}, {}] = useState({});{}", {
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
			i(0),
		})
	),
	s(
		"ust",
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
	s("ue", fmt("useEffect(() => {{{}}}, [{}]);{}", { i(1), i(2), i(0) })),
	s("cl", fmt("console.log({});{}", { i(1), i(0) })),
	s("ar", fmt("({}) => ({})", { i(1), i(0) })),
	s("arr", fmt("({}) => {{{}}}", { i(1), i(0) })),
	s("aro", fmt("({}) => ({{{}}})", { i(1), i(0) })),
	s(
		"proi",
		fmt(
			[[
interface {} {{
  {}
}}{}
  ]],
			{ i(1, "Props"), i(2), i(0) }
		)
	),
	s(
		"lorem",
		fmt(
			"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.{}",
			{ i(0) }
		)
	),
	s(
		"lorems",
		fmt(
			"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.{}",
			{ i(0) }
		)
	),
})
