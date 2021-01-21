--------------------------------------------------------------------------------
--- # Support for Picker Dollies movement
--------------------------------------------------------------------------------

-- Game globals
local _remote = remote

-- Libraries
local _event = require('__stdlib__/stdlib/event/event')

-- Classes
local StackCombinator = require("staco")


local PickerDollies = {}

--- Wire up the event handler
function PickerDollies:init()
  if _remote.interfaces["PickerDollies"] and _remote.interfaces["PickerDollies"]["dolly_moved_entity_id"] then
    _event.register(remote.call("PickerDollies", "dolly_moved_entity_id"), self.moved, filter)
  end
end

local function filter(ev)
  return ev.moved_entity and ev.moved_entity.name == StackCombinator.NAME
end

--- Move the output after moving stack combinator
function PickerDollies:moved(ev)
  _runtime:sc(ev.moved_entity).moved()
end

return PickerDollies