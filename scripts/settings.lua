----------------------------------------------------------------------------------------------------
--- Access to all mod settings
local Settings = {}
local StartupSettings = require("settings-startup")
local RuntimeSettings = require("settings-runtime")

local SIGNAL_CAPACITY = Mod.NAME .. "-signal-capacity"
local DEBUG_MODE = Mod.NAME .. "-debug-mode"

local INVERT_SIGNALS = Mod.NAME .. "-defaults-invert"

--- Startup settings
local startup = nil
--- Runtime settings
local runtime = nil


--- Access mod's startup settings
-- @treturn StartupSettings
function Settings.startup()
  if (not startup) then
    startup = {
      debug_mode = settings.startup[DEBUG_MODE].value or StartupSettings.debug_mode,
      signal_capacity = settings.startup[SIGNAL_CAPACITY].value or StartupSettings.signal_capacity
    }
    Mod.logger.debug("Startup settings: " .. serpent.line(startup))
  end
  return startup or error("Failed to load startup settings.")
end

--- Access mod's runtime settings
-- @treturn RuntimeSettings
function Settings.runtime(reload)
  if (not runtime) or (reload) then
    runtime = RuntimeSettings.new {
      invert_signals = settings.global[INVERT_SIGNALS].value
    }
    Mod.logger.debug("Runtime settings: " .. serpent.line(runtime))
  end
  return runtime or error("Failed to load runtime settings.")
end

----------------------------------------------------------------------------------------------------
return Settings