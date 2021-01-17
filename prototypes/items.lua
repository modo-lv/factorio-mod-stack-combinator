local sc = table.deepcopy(data.raw["item"]["arithmetic-combinator"])

sc.name = "stack-combinator"
sc.icon = "__stack-combinator__/graphics/icons/stack-combinator.png"
sc.order = "c[combinators]-s[stack-combinator]"
sc.place_result = "stack-combinator"

data:extend{sc}
