local table = require('__stdlib__/stdlib/utils/table')

if (mods["nullius"]) then
  log("Nullius mod detected, adjusting tech & recipe accordingly.")

  --- Tech
  local tech = data.raw["technology"]["stack-combinator"]
  tech.order = "nullius-" .. (tech.order or "s")
  tech.prerequisites = {
    "nullius-computation",
    "nullius-actuation-2"
  }

  --- Recipe
  local base = data.raw["recipe"]["stack-combinator"]
  local recipe = table.deepcopy(data.raw["recipe"]["nullius-arithmetic-circuit"])

  -- Nullius hides any recipes that it doesn't recognize
  recipe.name = base.name
  recipe.result = base.result
  recipe.ingredients = {
    { "arithmetic-combinator", 1 },
    { "turbo-inserter", 1 }
  }
  recipe.energy_required = math.ceil(recipe.energy_required / 2)

  --- Item
  local item = data.raw["item"]["stack-combinator"]
  item.order = "nullius-f-s"
  -- Remove hidden flag, if set
  item.flags = table.filter(item.flags, function(flag) return not flag == "hidden" end)


  data:extend { tech, recipe, item }
end