--------------------------------------------------------------------------------
--- Main control
-- Entry point of the mod, ties together all other parts.
--------------------------------------------------------------------------------

-- Avoid DebugAdapter warnings in VS Code Factorio Mod Debug.
if (__DebugAdapter and __DebugAdapter.defineGlobal) then __DebugAdapter.defineGlobal("Mod") end

--- Factorio Standard Library functions
Std = { }
Std.events = require('__stdlib__/stdlib/event/event')

-- Sequence matters! Mod.* objects depend on Mod & other Mod.* fields.
Mod = require("scripts/mod")
-- Settings must be first, since debug mode is read
Mod.settings = require("scripts/settings")
-- Debug must be first, since it provides logging functionality.
Mod.debug = require("scripts/debug")
-- Settings must be next, since they determine whether anything gets logged.
Mod.runtime = require("scripts/runtime")
Mod.gui = require("scripts/gui/gui")

-- Register mod events
require("scripts/mod-events").register_all()
require("scripts/runtime-events").register_all()
require("scripts/staco/staco-events").register_all()
require("scripts/gui/gui-events"):register_all()

-- Compatibility
require("scripts/other-mods/picker-dollies").register_all()
