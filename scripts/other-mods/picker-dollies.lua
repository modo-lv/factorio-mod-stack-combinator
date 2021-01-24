local events = require('__stdlib__/stdlib/event/event')

----------------------------------------------------------------------------------------------------
--- # Support for Picker Dollies movement
----------------------------------------------------------------------------------------------------

local PickerDollies = {}

--- Move the output after moving stack combinator
local function moved(ev)
  This.runtime:sc(ev.moved_entity):moved()
end

--- Wire up the event handler
-- Has to be called from within another event otherwise remote.call doesn't work
local function register()
  events.register(remote.call("PickerDollies", "dolly_moved_entity_id"), moved,
    function(ev) return ev.moved_entity and ev.moved_entity.name == This.StaCo.NAME end
  )
end

----------------------------------------------------------------------------------------------------

function PickerDollies.register_all()
  events.on_init(register)
  events.on_load(register)
end

----------------------------------------------------------------------------------------------------

return PickerDollies