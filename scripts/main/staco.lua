--------------------------------------------------------------------------------
--- # Main stack combinator class
--------------------------------------------------------------------------------

-- Game globals
local _serpent = serpent

local StackCombinator = {
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
function StackCombinator:run()
  local red = self.input.get_circuit_network(
    defines.wire_type.red,
    defines.circuit_connector_id.combinator_input
  )
  local green = self.input.get_circuit_network(
    defines.wire_type.green, 
    defines.circuit_connector_id.combinator_input
  )
  local cfg = self.config:load()

  local result = 
    this.stackify(green, cfg.invert_green, 
      this.stackify(red, cfg.invert_red))

  --- Not enough signal space
  if (table_size(result) > self.output.signals_count) then
    if not (Mod.runtime.signal_space_errors[sc.unit_number]) then
      Mod.runtime.signal_space_errors[sc.unit_number] = 
        { "gui.signal-space-error-description", table_size(result), output.signals_count }
    end
    for _, player in pairs(game.players) do
      player.add_custom_alert(
        self.input,                               -- Entity
        { type = "item", name = SC_ENTITY_NAME }, -- Icon (signal)
        signal_space_errors[sc.unit_number],      -- Text
        true                                      -- Show on map
      )
    end

    self.output.parameters = {}
    return
  end

  --- Clear the error if signal count is OK now
  if (Mod.runtime.signal_space_errors[self.id]) then
    Mod.runtime.signal_space_errors[self.id] = nil
    for _, player in pairs(game.players) do
      player.remove_alert {
        entity = self.input,
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
  
  self.output.parameters = result
end


--- Convert circuit network signal values to their stack sizes
-- @tparam LuaCircuitNetwork input
-- @tparam Boolean invert Multiply all stackified signal values by -1?
-- @param[opt] result Already processed signals from the other wire, if any
function StackCombinator.stackify(input, invert, result)
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


--- Create a StackCombinator instance for a placed SC entity
-- @tparam LuaEntity input In-game combinator entity
-- @tparam[opt] LuaEntity output In-game output combinator entity if one exists
function StackCombinator.created(input, output)
  if not (input and input.name == StackCombinator.NAME) then
    error("Tried to configure " .. input.name .. " as a static combinator.")
  end
  if (output and output.name ~= StackCombinator.Output.NAME) then
    error("Tried to configure " .. output.name .. " as a static combinator output.")
  end

  local sc = {}
  setmetatable(sc, { __index = StackCombinator })
  sc.id = input.unit_number
  sc.input = input
  sc.output = output or StackCombinator.Output.create(sc)
  sc.config = StackCombinator.Config.create(sc)
  return sc
end


--- In-game entity rotated
function StackCombinator:rotated()
  -- Rotate output as well
  self:debug_log("Input rotated, rotating output to match.")
  self.output.direction = self.direction
end


function StackCombinator:moved()
  -- Move output as well  
  self:debug_log("Input moved to " .. _serpent.line(self.input.position) .. ", moving output to match.")
  self.output.teleport(self.input.position)
end


--- In-game entity removed
function StackCombinator:destroyed()
  -- Input entity has already been destroyed, we need to remove the output
  self.output.destroy({ raise_destroy = false })
  self:debug_log("Output destroyed.")
end


--- Output a combinator-specific debug log message
-- @param message [LocalisedString] Text to output.
function StackCombinator:debug_log(message)
  Mod.debug:log("[SC-" .. self.id .. "] " .. message)
end


--------------------------------------------------------------------------------
return StackCombinator