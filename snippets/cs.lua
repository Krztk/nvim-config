local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node

local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("cs", {
	s(
		"fc",
		fmt(
			[[
  namespace {}
  {{
    public class {}
    {{
    {}
    }}
  }}
  ]],
			{ i(1), i(2), i(0) }
		)
	),
})
