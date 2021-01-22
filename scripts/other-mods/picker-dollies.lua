--------------------------------------------------------------------------------
--- # Support for Picker Dollies movement
--------------------------------------------------------------------------------

-- Libraries
local _event = require('__stdlib__/stdlib/event/event')

-- Classes
local StaCo = require("staco")

--------------------------------------------------------------------------------

local PickerDollies = {}

local function filter(ev)
  return ev.moved_entity and ev.moved_entity.name == StaCo.NAME
end

--- Move the output after moving stack combinator
local function moved(ev)
  Mod.runtime:sc(ev.moved_entity):moved()
end

--- Wire up the event handler
-- Has to be called from within an event otherwise remote.call doesn't work
local function register()
  _event.register(remote.call("PickerDollies", "dolly_moved_entity_id"), moved, filter)
end

function PickerDollies.register_all()
  _event.on_init(register)
  _event.on_load(register)
end


--------------------------------------------------------------------------------

return PickerDollies