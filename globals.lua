--- Explicitly define global variable to avoid DebugAdapter warnings
-- Only for mod development, does not do anything in the game.
local function g(var)
  if __DebugAdapter and __DebugAdapter.defineGlobal then __DebugAdapter.defineGlobal(var) end
end

--------------------------------------------------------------------------------
--- # Constants
--------------------------------------------------------------------------------
g("MOD_NAME") 
MOD_NAME = "stack-combinator"

g("SC_ENTITY_NAME")
SC_ENTITY_NAME = MOD_NAME

g("OUT_ENTITY_NAME")
OUT_ENTITY_NAME = SC_ENTITY_NAME .. "-output"

--------------------------------------------------------------------------------
--- # Transient
--- Cannot be used in data phase, erased when player quits the map.
--------------------------------------------------------------------------------

if (script) then
  --- Have all combinators been (re)registered?
  g("combinators_listed")
  combinators_listed = false

  --- Debug logger
  g("debug_log")
  debug_log = require("scripts.debug-log")

  -- Convenience shorthand
  g("dlog")
  dlog = debug_log.print

  g("signal_space_errors")
  --- Errors about insufficient signal capacity shown to the user
  signal_space_errors = {}
end


--------------------------------------------------------------------------------
--- # Persistent
--- Cannot be used in data phase, preserved in the savegame.
--------------------------------------------------------------------------------

-- WARNING: The values assigned here are for documentation purposes only,
-- `global` gets overwritten after a game is started/loaded.
if (global) then 
  global.all_combinators = nil

  --- SC entity that has its configuration GUI open
  -- Custom GUIs are not associated with entities, so we have to manually 
  -- keep track of which SC is currently open for configuration.
  global.open_sc = nil

  --- Unique persistent ID used in the debug log filename.
  -- Factorio does not allow or provide any way to read date/time or save name,
  -- so the only way to ensure the same log file over multiple saves is
  -- to manually generate and store a unique ID for each map.
  -- @see debug-log:print()
  global.dlog_id = 0
end