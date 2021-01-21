--------------------------------------------------------------------------------
--- # Main control
-- Entry point of the mod, ties together all other parts.
-- @type Control
--------------------------------------------------------------------------------

-- Avoid DebugAdapter warnings in VS Code Factorio Mod Debug.
if (__DebugAdapter and __DebugAdapter.defineGlobal) then
  for _, var in ipairs({"Game", "Settings", "Mod"}) do
    __DebugAdapter.defineGlobal(var)
  end
end

-- Consistent global naming
Game = nil -- unavailable until game started
Settings = settings

Mod = require("scripts/mod")
Mod.debug = require("scripts/debug")
Mod.settings = require("scripts/settings")
Mod.runtime = require("scripts/runtime")
Mod.events = require("scripts/mod/events")

-- Wire up events
Mod.events:register_all()
require("scripts/stack-combinator/events"):register_all()

-- Mod compatibility
require("scripts/other-mods/picker-dollies"):init()
