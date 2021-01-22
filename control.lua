--------------------------------------------------------------------------------
--- Main control
-- Entry point of the mod, ties together all other parts.
--------------------------------------------------------------------------------

require("globals")

--- Factorio Standard Library functions
Std = { }
Std.events = require('__stdlib__/stdlib/event/event')

Mod.gui = require("scripts/gui/gui")

-- Register mod events
require("scripts/mod-events").register_all()
require("scripts/runtime-events").register_all()
require("scripts/staco/staco-events").register_all()
require("scripts/gui/gui-events"):register_all()

-- Compatibility
require("scripts/other-mods/picker-dollies").register_all()
