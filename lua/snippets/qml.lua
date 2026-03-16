local ls = require "luasnip"
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {

  s("rect", {
    t "Rectangle {",
    t { "", "  width: " },
    i(1, "200"),
    t { "", "  height: " },
    i(2, "200"),
    t { "", '  color: "' },
    i(3, "#ffffff"),
    t '"',
    t { "", "}" },
  }),

  s("text", {
    t "Text {",
    t { "", '  text: "' },
    i(1, "Hello"),
    t '"',
    t { "", "  anchors.centerIn: parent" },
    t { "", "}" },
  }),
}
