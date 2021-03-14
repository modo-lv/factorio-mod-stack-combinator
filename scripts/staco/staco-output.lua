--------------------------------------------------------------------------------
--- # Constructor for the stack combinator output entity
--------------------------------------------------------------------------------
local StackCombinatorOutput = {
  NAME = "stack-combinator-output"
}

--- Create and connect the output combinator for an SC
-- @tparam StackCombinator sc The SC object for which this output is created.
-- @treturn LuaEntity The output combinator attached to the given SC input.
function StackCombinatorOutput.create(sc)
  local input = sc.input
  local output = input.surface.create_entity {
    name = StackCombinatorOutput.NAME,
    position = input.position,
    force = input.force,
    direction = input.direction,
    raise_built = false,
    create_built_effect_smoke = false
  }
  output.destructible = false
  output.operable = false

  sc:debug_log("Output constructed.")

  return output
end

--------------------------------------------------------------------------------
return StackCombinatorOutput