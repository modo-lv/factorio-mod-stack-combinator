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

local GuiInputOp = require("scripts/gui/gui-input-op")

local StaCoConfig = {
  --- Static combinator that this configuration is for
  sc = nil,

  --- Invert red inputs?
  invert_red = nil,

  --- Invert green inputs?
  invert_green = nil,

  --- Input operation
  operation = 1,
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

local op_map_write = {
  "*", -- 1
  "+", -- 2
  "/", -- 3
  "AND", -- 4
  "OR", -- 5
  "XOR", -- 6
}

--- Write SC's configuration
function StaCoConfig:save()
  local r, g = self.invert_red, self.invert_green
  local name = (r and g and "yellow") or (r and "red") or (g and "green") or ("black")
  local signal = { type = "virtual", name = "signal-" .. name }
  self.sc.input.get_or_create_control_behavior().parameters = {
    first_signal = signal,
    operation = op_map_write[self.operation]
  }
  self.sc:debug_log("Config: "
    .. "[img=item/red-wire] " .. tostring(self.invert_red) .. ", "
    .. "[img=item/green-wire] " .. tostring(self.invert_green) .. ", "
    .. "op = " .. GuiInputOp.item_names[self.operation] .. " (" .. self.operation ..")"
  )
end

local op_map_read = {
  ["*"] = 1,
  ["+"] = 2, -- divide with ceil
  ["/"] = 3, -- divide with floor
  ["AND"] = 4,
  ["OR"] = 5,
  ["XOR"] = 6,
}

--- Read SC's configuration, or create the default if there isn't one
function StaCoConfig:load_or_default()
  local params = self.sc.input.get_control_behavior().parameters

  -- Input inversion
  local signal = params.first_signal
  if (signal and signal.type == "virtual") then
    self.invert_red = signal.name == "signal-red" or signal.name == "signal-yellow"
    self.invert_green = signal.name == "signal-green" or signal.name == "signal-yellow"
  else
    self.sc:debug_log("No valid configuration (signal is " .. _serpent.line(signal) .. "), resetting to defaults.")
    _table.merge(self, self.defaults())
  end

  -- Operation
  local op = params.operation
  self.operation = op_map_read[op]

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