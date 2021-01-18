--------------------------------------------------------------------------------
--- # Convert stack settings to/from arithmetic combinator
-- Since Factorio doesn't support storing arbitrary data for built entities,
-- in order to support Blueprints we must convert stack size combinator setings
-- to a signal we can store in built-in arithmetic combinator parameters.
--------------------------------------------------------------------------------

local this = {
  signal_to_config = {},
  config_to_signal = {}
}

this.signal_to_config["signal-everything"] = { invert_red = true, invert_green = true }
this.signal_to_config["signal-red"] = { invert_red = true, invert_green = false }
this.signal_to_config["signal-green"] = { invert_red = false, invert_green = true }
this.config_to_signal[true] = {}
this.config_to_signal[true][false] = { type= "virtual", name = "signal-red" }
this.config_to_signal[true][true] = { type= "virtual", name = "signal-everything" }
this.config_to_signal[false] = {}
this.config_to_signal[false][true] = { type= "virtual", name = "signal-green"}


--- Convert configuration to signal
function this.to_signal(config)
  return this.config_to_signal[config.invert_red or false][config.invert_green or false]
end

--- Convert a signal to the corresponding SC configuration
function this.to_config(signal)
  return this.signal_to_config[signal and signal.name] or {}
end

--- Read configuration from a stack combinator
function this.from_combinator(sc)
  local signal = sc.get_control_behavior().parameters.first_signal
  return this.to_config(signal)
end

--- Write configuration to a stack combinator
function this.to_combinator(sc, config)
  local signal = this.to_signal(config)
  sc.get_control_behavior().parameters = {
    first_signal = signal
  }
end

return this