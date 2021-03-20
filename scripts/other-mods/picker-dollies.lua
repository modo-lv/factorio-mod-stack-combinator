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
  if not (game.active_mods["PickerDollies"]) then return end
  Mod.logger:debug("Picker Dollies detected, registering move handler.")
  events.register(remote.call("PickerDollies", "dolly_moved_entity_id"), moved,
    function(ev) return ev.moved_entity and ev.moved_entity.name == This.StaCo.NAME end
  )
end

--- Wire up the event handler on the first tick.
local function register_tick()
  register()
  events.remove(defines.events.on_tick, register_tick)
end

----------------------------------------------------------------------------------------------------

function PickerDollies.register_all()
  -- Unlike on_tick, this event also gets fired in map editor.
  events.register(defines.events.on_player_joined_game, register)

  -- Unlike on_player_joined_game, on_tick ensures that all mods have been added to
  -- `game.active_mods` before firing
  events.register(defines.events.on_tick, register_tick)
end

----------------------------------------------------------------------------------------------------

return PickerDollies