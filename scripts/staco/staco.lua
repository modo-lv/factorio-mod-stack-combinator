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

  local op = self.config.operation
  local result = self.stackify(green, self.config.invert_green, op, self.stackify(red, self.config.invert_red, op))

  local output = self.output.get_control_behavior()

  local total = table_size(result)
  if (
    self.input.status == defines.entity_status.no_power
      or self.input.status == defines.entity_status.low_power
  ) then
    output.parameters = nil
  elseif (This.runtime:signal_overflow(self, total)) then
    --- Not enough signal space
    output.parameters = nil
  else
    local i = 1
    for _, entry in pairs(result) do
      entry.index = i
      i = i + 1
      if (entry.count > 2147483647) then
        entry.count = 2147483647
      elseif (entry.count < -2147483647) then
        entry.count = -2147483647
      end
    end

    output.parameters = result
  end
end

--- Convert circuit network signal values to their stack sizes
-- @tparam LuaCircuitNetwork input
-- @tparam Boolean invert Multiply all stackified signal values by -1?
-- @tparam Int op Operation to perform
-- @param[opt] result Already processed signals from the other wire, if any
function StaCo.stackify(input, invert, operation, result)
  result = result or {}
  if (not input or not input.signals) then
    return result
  end
  local multiplier = invert and -1 or 1

  for _, entry in ipairs(input.signals) do
    local name = entry.signal.name
    local value = entry.count
    if (entry.signal.type == "item") then
      local stack = game.item_prototypes[name].stack_size
      local op = operation
      if (op == 1) then
        -- Multiply
        value = value * stack * multiplier
      elseif (op == 2) then
        -- Divide
        value = value / stack * multiplier
      elseif (op == 3) then
        -- Round
        op = math.abs(value) >= stack / 2 and 4 or 5
      end

      if (op == 4 or op == 5) then
        local func = nil
        if (op == 4 and value >= 0) or (op == 5 and value < 0) then
          func = math.ceil
        else
          func = math.floor
        end

        value = func(value / stack) * stack * multiplier
      end
    end

    if (result[name]) then
      result[name].count = result[name].count + value
    else
      result[name] = { signal = entry.signal, count = value }
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
  setmetatable(sc, { __index = StaCo })
  sc.id = input.unit_number
  sc.input = input
  sc.output = output or StaCo.Output.create(sc)
  sc:connect()
  sc.config = StaCo.Config.create(sc)
  return sc
end

--- Connect the output combinator to the stack combinator's output
--- so that when player connects to the SC's output (which outputs nothing),
--- the OC's signals are on the same wires.
function StaCo:connect()
  self.input.connect_neighbour({
    wire = defines.wire_type.red,
    target_entity = self.output,
    source_circuit_id = defines.circuit_connector_id.combinator_output,
    target_circuit_id = defines.circuit_connector_id.constant_combinator
  })
  self.input.connect_neighbour({
    wire = defines.wire_type.green,
    target_entity = self.output,
    source_circuit_id = defines.circuit_connector_id.combinator_output,
    target_circuit_id = defines.circuit_connector_id.constant_combinator
  })
  self:debug_log("Output connected to input.")
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
  -- Close GUI for all players
  if (This.gui.staco == self) then
    for _, player in pairs(game.players) do
      This.gui:destroy(player)
    end
  end
  -- Input entity has already been destroyed, we need to remove the output
  self.output.destroy({ raise_destroy = false })
  self:debug_log("Output destroyed.")
end

--- Output a combinator-specific debug log message
-- @param message [LocalisedString] Text to output.
function StaCo:debug_log(message)
  Mod.logger:debug("[SC-" .. self.id .. "] " .. message)
end

--------------------------------------------------------------------------------
return StaCo
