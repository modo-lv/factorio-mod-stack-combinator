--------------------------------------------------------------------------------
--- # Main control
-- Entry point of the mod, ties together all other parts.
--------------------------------------------------------------------------------

-- Avoid DebugAdapter warnings in VS Code Factorio Mod Debug.
if (__DebugAdapter and __DebugAdapter.defineGlobal) then
  for _, var in ipairs({"Game", "Settings", "Mod", "Remote"}) do
    __DebugAdapter.defineGlobal(var)
  end
end

-- Consistent global naming
Game = nil -- unavailable until game started
Settings = settings
Remote = remote

-- Sequence matters! Mod.* objects depend on Mod & other Mod.* objects.
Mod = require("scripts/mod")
Mod.debug = require("scripts/debug")
Mod.settings = require("scripts/settings")
Mod.runtime = require("scripts/runtime")
Mod.gui = require("scripts/gui/gui")

-- Register mod events
require("scripts/mod-events").register_all()
require("scripts/runtime-events").register_all()
require("scripts/main/staco-events").register_all()
require("scripts/gui/gui-events"):register_all()

-- Compatibility
require("scripts/other-mods/picker-dollies").register_all()
