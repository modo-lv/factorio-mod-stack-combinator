local StaCo = require("scripts/staco/staco")

local sc = table.deepcopy(data.raw["item"]["arithmetic-combinator"])

sc.name = "stack-combinator"
sc.icon = "__stack-combinator__/graphics/icons/stack-combinator.png"
sc.order = "c[combinators]-s[stack-combinator]"
sc.place_result = StaCo.NAME
-- Prevent other mods overriding AC's localisation from propagating to StaCo
sc.localised_name = nil
sc.localised_description = nil


data:extend{sc}
