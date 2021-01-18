--------------------------------------------------------------------------------
--- # Recipes for building stack combiantors
--------------------------------------------------------------------------------

local parent = data.raw["recipe"]["arithmetic-combinator"]

local recipe = {
  type = "recipe",
  name = "stack-combinator",
  normal = {
    enabled = false,
    result = "stack-combinator",
    -- A stack combinator is basically a hacked AC, so the crafting price should 
    -- reflect that.
    ingredients = { 
      -- One arithmetic combinator
      { parent.name, 1 },
      -- A repair pack (closest thing Factorio has to a generit "tool" item)
      { "repair-pack", 1 }
    },
    -- And a little effort
    energy_required = 2.5,
  }
}

-- Everything costs double in expensive mode
recipe.expensive = table.deepcopy(recipe.normal)
for _, ingredient in ipairs(recipe.expensive.ingredients) do
  ingredient[2] = ingredient[2] * 2
end
recipe.expensive.energy_required = recipe.expensive.energy_required * 2

data:extend{recipe}