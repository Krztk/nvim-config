local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local d = ls.dynamic_node
local sn = ls.snippet_node

local fmt = require("luasnip.extras.fmt").fmt

local function format_filename(fname)
  return vim.fn.substitute(fname, "^\\(.\\)", "\\u\\1", "g")
end

ls.add_snippets("cs", {
  s("ns", fmt("namespace ", {})),
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
  s(
    "cla",
    fmt(
      [[
  public class {}
  {{
  {}
  }}
      ]],
      {
        d(1, function(_, snip)
          return sn(1, {
            i(1, format_filename(snip.env.TM_FILENAME_BASE)),
          })
        end, {}),
        i(0),
      }
    )
  ),
  s(
    "clas",
    fmt(
      [[
  public sealed class {}
  {{
  {}
  }}
      ]],
      {
        d(1, function(_, snip)
          return sn(1, {
            i(1, format_filename(snip.env.TM_FILENAME_BASE)),
          })
        end, {}),
        i(0),
      }
    )
  ),
  s(
    "inter",
    fmt(
      [[
  public interface {}
  {{
  {}
  }}
      ]],
      {
        d(1, function(_, snip)
          return sn(1, {
            i(1, format_filename(snip.env.TM_FILENAME_BASE)),
          })
        end, {}),
        i(0),
      }
    )
  ),
  s(
    "ctor",
    fmt(
      [[
  public {}({})
  {{
    {}
  }}
  ]],
      {
        d(1, function(_, snip)
          return sn(1, {
            i(1, format_filename(snip.env.TM_FILENAME_BASE)),
          })
        end, {}),
        i(2),
        i(0),
      }
    )
  ),
  s(
    "log",
    fmt(
      [[
  Console.WriteLine("{}");{}
      ]],
      { i(1), i(0) }
    )
  ),

  --godot
  s("gp", fmt([[GD.Print("{}");{}]], { i(1), i(0) })),
  s(
    "gn",
    fmt([[GetNode<{}>("{}");{}]], {
      i(1),
      d(2, function(args)
        return sn(nil, {
          i(1, args[1]),
        })
      end, { 1 }),
      i(0),
    })
  ),
})
