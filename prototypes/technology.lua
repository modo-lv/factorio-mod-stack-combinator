----------------------------------------------------------------------------------------------------
--- # Technology required to build stack combinators ---
----------------------------------------------------------------------------------------------------

local parent = data.raw["technology"]["circuit-network"]

local tech = {
  type = "technology",
  name = "stack-combinator",
  prerequisites = { parent.name },
  unit = table.deepcopy(parent.unit),
  icons = util.technology_icon_constant_stack_size("__base__/graphics/technology/circuit-network.png"),
  effects = {
    {
      type = "unlock-recipe",
      recipe = "stack-combinator"
    }
  }
}

-- Use a fraction of the main technology costs to remain balanced when the tech tree is modded.
tech.unit.count = math.ceil(tech.unit.count / 4)
tech.unit.time = math.ceil(tech.unit.time / 4)

data:extend{tech}