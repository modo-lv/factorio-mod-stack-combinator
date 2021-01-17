local sc = table.deepcopy(data.raw["item"]["arithmetic-combinator"])
local out = table.deepcopy(data.raw["item"]["constant-combinator"])
local empty_box = {{0, 0}, {0, 0}}

sc.name = "stack-combinator"
sc.icon = "__stack-combinator__/graphics/icons/stack-combinator.png"
sc.order = "c[combinators]-s[stack-combinator]"
sc.place_result = "stack-combinator"

data:extend{sc}