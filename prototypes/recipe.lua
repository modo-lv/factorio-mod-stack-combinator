----------------------------------------------------------------------------------------------------
--- # Recipes for building stack combinators
----------------------------------------------------------------------------------------------------

local recipe = table.deepcopy(data.raw["recipe"]["arithmetic-combinator"])

recipe.name = "stack-combinator"
recipe.enabled = false
recipe.result = "stack-combinator"
-- A stack combinator is basically a hacked AC, so the crafting price should reflect that.
recipe.ingredients = {
  { "arithmetic-combinator", 1 },
  { "repair-pack", 1 }
}
-- Prevent other mods overriding AC's localisation from propagating to StaCo
recipe.localised_name = nil
recipe.localised_description = nil

data:extend{recipe}