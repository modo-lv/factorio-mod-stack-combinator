----------------------------------------------------------------------------------------------------
--- Startup settings
local StartupSettings = {
  -- Defaults
  debug_mode = false,
  signal_capacity = 20,

  NAMES = {
    debug_mode = Mod.NAME .. "-debug-mode",
    signal_capacity = Mod.NAME .. "-signal-capacity"
  }
}

----------------------------------------------------------------------------------------------------
return StartupSettings