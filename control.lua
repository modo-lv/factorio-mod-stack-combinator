require("globals")

--------------------------------------------------------------------------------
--- Main control
-- Entry point of the mod, calls event setups to tie together all the parts of
-- the mod.
--------------------------------------------------------------------------------

-- This mod
require("scripts/staco/event-setup").register_all()
require("scripts/gui/event-setup"):register_all()

-- Other mods
require("scripts/other-mods/picker-dollies").register_all()
require("scripts/other-mods/compaktcircuits").register_all()
