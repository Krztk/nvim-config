local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

-- https://www.youtube.com/watch?v=FmHhonPjvvA

ls.add_snippets("markdown", {
	s("cb", {
		t({ "```", "" }), -- table for "new line"
		i(1),
		t({ "", "```" }),
	}),
	s("cbl", {
		t("```"),
		i(1),
		t({ "", "" }),
		i(2),
		t({ "", "```" }),
		i(0),
	}),
})
