--------------------------------------------------------------------------------
--- # A stack combinators configuration
-- Since Factorio doesn't allow arbitrary data attachment to entities, we use
-- the built-in arithmetic combinator's settings to store what we need in order
-- to ensure compatibility with vanilla functions (such as Blueprints).
-- @type StackCombinatorConfig
--------------------------------------------------------------------------------
-- Global imports
local _serpent = serpent
local _table = require('__stdlib__/stdlib/utils/table')

local StackCombinatorConfig = {
  --- Static combinator that this configuration is for
  sc = nil,

  --- Invert red inputs?
  invert_red = nil,

  --- Invert green inputs?
  invert_green = nil
}



--- Instantiate a configuration object for a stack combinator
-- @tparam StackCombinator Stack combinator that this configuration is for
-- @treturn StackCombinatorConfig Created configuration object
function StackCombinatorConfig.create(sc)
  local config = { sc = sc }
  setmetatable(config, { __index = StackCombinatorConfig })
  config:load_or_default()
  return config
end


--- Write SC's configuration
function StackCombinatorConfig:save()
  local r, g = self.invert_red, self.invert_green
  local name = (r and g and "yellow") or (r and "red") or (g and "green") or ("black")
  local signal = { type = "virtual", name = "signal-" .. name }
  self.sc.input.get_or_create_control_behavior().parameters = {
    first_signal = signal
  }
  self.sc:debug_log("Configured: ")
end


--- Read SC's configuration, or create the default if there isn't one
function StackCombinatorConfig:load_or_default()
  local signal = self.sc.input.get_control_behavior().parameters.first_signal
  if (signal and signal.type == "virtual") then
    self.invert_red = signal.name == "signal-red" or signal.name == "signal-yellow"
    self.invert_green = signal.name == "signal-green" or signal.name == "signal-yellow"
  else
    self.sc:debug_log("Combinator has no [valid] configuration (signal is " .. _serpent.line(signal) .. "), resetting to defaults.")
    _table.merge(self, Mod.settings.default_config)
    self:save()
  end

  return self
end


--------------------------------------------------------------------------------
return StackCombinatorConfig