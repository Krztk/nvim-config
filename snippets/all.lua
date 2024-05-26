local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node

local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("all", {
	s(
		"ct",
		fmt(
			[[
      CREATE TABLE {}
      (
        {} 
      );
      ]],
			{ i(1), i(0) }
		)
	),
	s("inn", fmt("INT NOT NULL", {})),
	s("in", fmt("INT NULL", {})),
	s("vcnn", fmt("VARCHAR({}) NOT NULL", { i(1) })),
	s("vcn", fmt("VARCHAR({}) NULL", { i(1) })),
	s("cpk", fmt("CONSTRAINT PK_{} PRIMARY KEY({})", { i(1), i(2) })),
})
