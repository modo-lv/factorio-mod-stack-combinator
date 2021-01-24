--------------------------------------------------------------------------------
--- Main stack combinator class
--------------------------------------------------------------------------------
local StaCo = {
  --[[ Constants ]]
  NAME = "stack-combinator",
  --[[ Classes ]]
  Output = require("staco-output"),
  Config = require("staco-config"),
  --[[ Instance fields ]]
  --- Unique ID for this SC
  id = nil,
  --- The in-game stack-combinator entity
  input = nil,
  --- The in-game stack-combinator-output entity
  output = nil,
  --- SC configuration
  config = nil
}

--- Main combinator logic, process inputs into stackified output
function StaCo:run()
  local red = self.input.get_circuit_network(defines.wire_type.red, defines.circuit_connector_id.combinator_input)
  local green = self.input.get_circuit_network(defines.wire_type.green, defines.circuit_connector_id.combinator_input)

  local result = self.stackify(green, self.config.invert_green, self.stackify(red, self.config.invert_red))

  local output = self.output.get_control_behavior()

  local total = table_size(result)
  if (This.runtime:signal_overflow(self, total)) then
    --- Not enough signal space
    output.parameters = nil
  else
    local i = 1
    for _, entry in pairs(result) do
      entry.index = i
      i = i + 1
    end

    output.parameters = result
  end
end

--- Convert circuit network signal values to their stack sizes
-- @tparam LuaCircuitNetwork input
-- @tparam Boolean invert Multiply all stackified signal values by -1?
-- @param[opt] result Already processed signals from the other wire, if any
function StaCo.stackify(input, invert, result)
  result = result or {}
  if (not input or not input.signals) then
    return result
  end
  local multiplier = 1
  if (invert) then
    multiplier = -1
  end

  for _, entry in ipairs(input.signals) do
    local name = entry.signal.name
    local stack = entry.count
    if (entry.signal.type == "item") then
      stack = stack * game.item_prototypes[name].stack_size * multiplier
    end
    if (result[name]) then
      result[name].count = result[name].count + stack
    else
      result[name] = {signal = entry.signal, count = stack}
    end
  end
  return result
end

--- Create a StackCombinator instance for a placed SC entity
-- @tparam LuaEntity input In-game combinator entity
-- @tparam[opt] LuaEntity output In-game output combinator entity if one exists
function StaCo.created(input, output)
  if not (input and input.name == StaCo.NAME) then
    error("Tried to configure " .. input.name .. " as a static combinator.")
  end
  if (output and output.name ~= StaCo.Output.NAME) then
    error("Tried to configure " .. output.name .. " as a static combinator output.")
  end

  local sc = {}
  setmetatable(sc, {__index = StaCo })
  sc.id = input.unit_number
  sc.input = input
  sc.output = output or StaCo.Output.create(sc)
  sc.config = StaCo.Config.create(sc)
  return sc
end

--- In-game entity rotated
function StaCo:rotated()
  -- Rotate output as well
  self:debug_log("Input rotated, rotating output to match.")
  self.output.direction = self.input.direction
end

function StaCo:moved()
  -- Move output as well
  self:debug_log("Input moved to " .. serpent.line(self.input.position) .. ", moving output to match.")
  self.output.teleport(self.input.position)
end

--- In-game entity removed
function StaCo:destroyed()
  -- Input entity has already been destroyed, we need to remove the output
  self.output.destroy({raise_destroy = false})
  self:debug_log("Output destroyed.")
end

--- Output a combinator-specific debug log message
-- @param message [LocalisedString] Text to output.
function StaCo:debug_log(message)
  Mod.logger:debug("[SC-" .. self.id .. "] " .. message)
end

--------------------------------------------------------------------------------
return StaCo
