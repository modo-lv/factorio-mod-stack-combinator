--------------------------------------------------------------------------------
--- # Main stack combinator class
--------------------------------------------------------------------------------

-- Game globals
local _serpent = serpent
-- Components
local _debug = Mod.debug

local StackCombinator = {
  --[[ Constants ]]
  INPUT_NAME = "stack-combinator",
  
  --[[ Classes ]]
  Output = require("stack-combinator/output"),
  Config = require("stack-combinator/config"),

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



--- Create a StaticCombinator instance for a placed SC entity
-- @tparam LuaEntity input In-game combinator entity
-- @tparam[opt] LuaEntity output In-game output combinator entity if one exists
function StackCombinator.created(input, output)
  if not (input and input.name == StackCombinator.INPUT_NAME) then
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
  self.debug_log("Input rotated, rotating output to match.")
  self.output.direction = self.direction
end


function StackCombinator:moved()
  -- Move output as well  
  self.debug_log("Input moved to " .. _serpent.line(self.input.position) .. ", moving output to match.")
  self.output.teleport(self.input.position)
end


--- In-game entity removed
function StackCombinator:destroyed()
  -- Input entity has already been destroyed, we need to remove the output
  self.debug_log("Input destroyed, removing output as well.")
  self.output.destroy({ raise_destroy = false })
end


--- Output a combinator-specific debug log message
-- @param message [LocalisedString] Text to output.
function StackCombinator:debug_log(message)
  _debug:log("[" .. self.id .. "] " .. message)
end


--------------------------------------------------------------------------------
return StackCombinator