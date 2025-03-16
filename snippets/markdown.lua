local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

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
	s("link", fmt("[{}]({}){}", { i(1, "description"), i(2), i(0) })),
})
