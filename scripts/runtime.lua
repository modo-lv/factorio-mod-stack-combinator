--------------------------------------------------------------------------------
--- # Main combinator logic
--------------------------------------------------------------------------------

local sc_config = require("entity-config")

local this = {}

--- Main combinator logic, process combinator inputs into stackified output
-- @param sc Stack combinator entity
-- @param input LuaArithmeticCombinatorControlBehavior
-- @param output LuaConstantCombinatorControlBehavior
function this.process(sc, input, output)
  local config_signal = sc_config.get_signal(input)
  local red = input.get_circuit_network(defines.wire_type.red, defines.circuit_connector_id.combinator_input)
  local green = input.get_circuit_network(defines.wire_type.green, defines.circuit_connector_id.combinator_input)

  local result = this.stackify(green, sc_config.is_inverted(green, config_signal),
    this.stackify(red, sc_config.is_inverted(red, config_signal))
  )

  --- Not enough signal space
  if (table_size(result) > output.signals_count) then
    if not (signal_space_errors[sc.unit_number]) then
      signal_space_errors[sc.unit_number] = {"gui.signal-space-error-description", table_size(result), output.signals_count}
    end
    for _, player in pairs(game.players) do
      player.add_custom_alert(sc, { type = "item", name = SC_ENTITY_NAME }, signal_space_errors[sc.unit_number], true)
    end

    output.parameters = {}
    return
  end

  --- Clear the error if signal count is OK now
  if (signal_space_errors[sc.unit_number]) then
    signal_space_errors[sc.unit_number] = nil
    for _, player in pairs(game.players) do
      player.remove_alert {
        entity = sc,
        type = defines.alert_type.custom,
        icon = { type = "item", name = SC_ENTITY_NAME }
      }
    end
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