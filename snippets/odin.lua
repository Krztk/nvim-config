local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local d = ls.dynamic_node
local sn = ls.snippet_node

local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("odin", {
  s(
    "struct",
    fmt(
      [[
{} :: struct {{
    {}
}}{}
  ]],
      { i(1), i(2), i(0) }
    )
  ),
  s("pm", fmt([[package main]], {})),
  s("pp", fmt([[package {}]], { i(0) })),
  s("irl", fmt([[import rl "vendor:raylib"]], {})),
  s("ic", fmt([[import "core:{}"]], { i(0) })),
  s("icm", fmt([[import "core:math"]], {})),
  s("ics", fmt([[import "core:string"]], {})),
  s("ifmt", fmt([[import "core:fmt"]], {})),
  s(
    "proc",
    fmt(
      [[
{} :: proc({}) {{
    {}
}}

]],
      { i(1), i(2), i(0) }
    )
  ),
  s(
    "procr",
    fmt(
      [[
{} :: proc({}) -> {} {{
    {}
}}

]],
      { i(1), i(2), i(3), i(0) }
    )
  ),
  s("log", fmt([[fmt.println("{}"){}]], { i(1), i(0) })),
  s("logf", fmt([[fmt.printfln("{}", {}){}]], { i(1), i(2), i(0) })),
})
