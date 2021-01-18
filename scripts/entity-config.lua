--------------------------------------------------------------------------------
--- # Convert stack settings to/from arithmetic combinator
-- Since Factorio doesn't support storing arbitrary data for built entities,
-- in order to support Blueprints we must convert stack size combinator setings
-- to a signal we can store in built-in arithmetic combinator parameters.
--------------------------------------------------------------------------------

local mod_config = require("mod-config")

local this = {}

--- Should the input be inverted?
-- @param circuit_network LuaCircuitNetwork
-- @param config_signal SignalID indicating the stack combinator configuration
function this.is_inverted(circuit_network, config_signal)
  if not (circuit_network) then return false end
  local red_or_green = circuit_network.wire_type == defines.wire_type.red
  return config_signal.name == "signal-yellow" or config_signal.name == (red_or_green and "signal-red" or "signal-green")
end

--- Get the configuration signal from a stack size combinator.
-- @param input LuaEntity or LuaArithmeticCombinatorControlBehavior
function this.get_signal(input)
  if (input.type == defines.control_behavior.type.arithmetic_combinator) then
    return input.parameters.first_signal
  elseif (input.type == "arithmetic-combinator" and input.name == SC_ENTITY_NAME) then
    return input.get_or_create_control_behavior().parameters.first_signal
  else
    error("Stack combinator configuration can't be read from " .. input.name .. " (" .. input.type .. ")!")
  end
end

function this.from_combinator(sc)
  local s = this.get_signal(sc)
  return s.type == "virtual" and {
    invert_red = s.name == "signal-red" or s.name == "signal-yellow",
    invert_green = s.name == "signal-green" or s.name == "signal-yellow"
  } or nil
end

function this.to_combinator(sc, config)
  local r, g = config.invert_red, config.invert_green
  local name = (r and g and "yellow") or (r and "red") or (g and "green") or ("black")
  local signal = { type = "virtual", name = "signal-" .. name }
  sc.get_or_create_control_behavior().parameters = {
    first_signal = signal
  }
end

return this