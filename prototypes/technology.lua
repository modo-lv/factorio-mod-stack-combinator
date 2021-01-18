--------------------------------------------------------------------------------
--- # Technology required to build stack combiantors
--------------------------------------------------------------------------------

local parent = data.raw["technology"]["circuit-network"]

local tech = {
  type = "technology",
  name = "stack-combinator",
  prerequisites = { parent.name },
  unit = parent.unit,
  icons = util.technology_icon_constant_stack_size("__base__/graphics/technology/circuit-network.png"),
  effects = {
    {
      type = "unlock-recipe",
      recipe = "stack-combinator"
    }
  }
}

-- Use a fraction of the main circuit network technology costs so that SC tech
-- remains balanced when the tech tree is modded.
tech.unit.count = tech.unit.count / 4

data:extend{tech}