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

  -- Connect the output combinator to the stack combinator's output
  -- so that when player connects to the SC's output (which outputs nothing),
  -- the OC's signals are on the same wires.
  input.connect_neighbour({
    wire = defines.wire_type.red, 
    target_entity = output, 
    source_circuit_id = defines.circuit_connector_id.combinator_output,
    target_circuit_id = defines.circuit_connector_id.constant_combinator
  })
  input.connect_neighbour({
      wire = defines.wire_type.green,
      target_entity = output,
      source_circuit_id = defines.circuit_connector_id.combinator_output,
      target_circuit_id = defines.circuit_connector_id.constant_combinator
  })

  sc:debug_log("Output constructed and connected.")

  return output
end

--------------------------------------------------------------------------------
return StackCombinatorOutput