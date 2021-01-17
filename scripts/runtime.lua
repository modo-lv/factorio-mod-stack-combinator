--------------------------------------------------------------------------------
--- # Main combinator logic
--------------------------------------------------------------------------------

local this = {}

--- Main combinator logic, process combinator inputs into stackified output
-- @param config Stack combinator entity configuration
-- @param input LuaArithmeticCombinatorControlBehavior
-- @param output LuaConstantCombinatorControlBehavior
function this.process(config, input, output)
  local red = input.get_circuit_network(defines.wire_type.red, defines.circuit_connector_id.combinator_input)
  local green = input.get_circuit_network(defines.wire_type.green, defines.circuit_connector_id.combinator_input)

  local result = this.stackify(green, config.invert_green,
    this.stackify(red, config.invert_red)
  )

  if (#result > output.signals_count) then
    -- TODO: Warn player to increase signal capacity
  end
  
  local i = 1
  for _, entry in pairs(result) do
    entry.index = i
    i = i + 1
  end
  
  output.parameters = result
end

--- Convert a circuit network signal values to their stack sizes
-- @param input LuaCircuitNetwork
-- @param invert Multiply all stackified signal values by -1?
-- @param result Already processed signals from the other wire
function this.stackify(input, invert, result)
  result = result or {}
  if (not input or not input.signals) then return result end
  local multiplier = 1 if (invert) then multiplier = -1 end

  for _, entry in ipairs(input.signals) do
    local name = entry.signal.name
    local stack = entry.count
    if (entry.signal.type == "item") then
      stack = stack * game.item_prototypes[name].stack_size * multiplier
    end
    if (result[name]) then
      result[name].count = result[name].count + stack
    else
      result[name] = { signal = entry.signal, count = stack }
    end
  end
  return result
end

return this