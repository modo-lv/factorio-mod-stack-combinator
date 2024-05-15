--------------------------------------------------------------------------------
--- # Constructor for the stack combinator output entity
--------------------------------------------------------------------------------
local StackCombinatorOutput = {
  --[[ Constants ]]
  NAME = "stack-combinator-output",
  PACKED_NAME = 'stack-combinator-output-packed',
  SEARCH_NAMES = "stack-combinator-output",
  MATCH_NAMES = { ["stack-combinator-output"] = true },
}

--- Return the name for the output, depending on the input
---@param input LuaEntity
---@return string name The name of the stack combinator output entity
function StackCombinatorOutput.determine_name(input)
  assert(input and input.valid, "Input is not valid!")
  return ((input.name == This.StaCo.NAME) and StackCombinatorOutput.NAME) or StackCombinatorOutput.PACKED_NAME
end


--- Create and connect the output combinator for an SC
-- @tparam StackCombinator sc The SC object for which this output is created.
-- @treturn LuaEntity The output combinator attached to the given SC input.
function StackCombinatorOutput.create(sc)
  local input = sc.input
  local output_name = StackCombinatorOutput.determine_name(input)

  local output = input.surface.create_entity {
    name = output_name,
    position = input.position,
    force = input.force,
    direction = input.direction,
    raise_built = false,
    create_built_effect_smoke = false
  }
  output.destructible = false
  output.operable = false

  sc:debug_log(string.format("Output constructed (%s).", output_name))

  return output
end

--------------------------------------------------------------------------------
return StackCombinatorOutput