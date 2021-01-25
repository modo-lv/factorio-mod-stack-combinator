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

local StaCoConfig = {
  --- Static combinator that this configuration is for
  sc = nil,

  --- Invert red inputs?
  invert_red = nil,

  --- Invert green inputs?
  invert_green = nil
}

--- Instantiate a configuration object for a stack combinator
-- @tparam StaCo Stack combinator that this configuration is for
-- @treturn StaCoConfig Created configuration object
function StaCoConfig.create(sc)
  local config = { sc = sc }
  setmetatable(config, { __index = StaCoConfig })
  config:load_or_default()
  return config
end

--- Write SC's configuration
function StaCoConfig:save()
  local r, g = self.invert_red, self.invert_green
  local name = (r and g and "yellow") or (r and "red") or (g and "green") or ("black")
  local signal = { type = "virtual", name = "signal-" .. name }
  self.sc.input.get_or_create_control_behavior().parameters = { first_signal = signal }
  local output = _table.deep_copy(self)
  output.sc = nil
  self.sc:debug_log("Configured:\n  Invert: "
    .. "[img=item/red-wire] = " .. tostring(self.invert_red) .. ", "
    .. "[img=item/green-wire] = " .. tostring(self.invert_green)
  )
end

--- Read SC's configuration, or create the default if there isn't one
function StaCoConfig:load_or_default()
  local signal = self.sc.input.get_control_behavior().parameters.first_signal
  if (signal and signal.type == "virtual") then
    self.invert_red = signal.name == "signal-red" or signal.name == "signal-yellow"
    self.invert_green = signal.name == "signal-green" or signal.name == "signal-yellow"
  else
    self.sc:debug_log("No valid configuration (signal is " .. _serpent.line(signal) .. "), resetting to defaults.")
    _table.merge(self, self.defaults())
  end

  self:save()
  return self
end

function StaCoConfig.defaults()
  local cfg = Mod.settings:runtime()
  return {
    invert_red = cfg.invert_signals == "red" or cfg.invert_signals == "both",
    invert_green = cfg.invert_signals == "green" or cfg.invert_signals == "both"
  }
end

--------------------------------------------------------------------------------
return StaCoConfig