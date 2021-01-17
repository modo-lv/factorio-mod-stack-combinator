--------------------------------------------------------------------------------
--- # Compatibility with Picker Dollies
--------------------------------------------------------------------------------

local this = {}

--- Wire up the event handler
function this.init()
  if remote.interfaces["PickerDollies"] and remote.interfaces["PickerDollies"]["dolly_moved_entity_id"] then
    script.on_event(remote.call("PickerDollies", "dolly_moved_entity_id"), this.moved)
  end
end

--- Move the output after moving stack combinator
function this.moved(ev)
  local sc = ev.moved_entity
  if not (sc and sc.name == SC_ENTITY_NAME) then return end
  dlog("Combinator " .. sc.unit_number .. " moved by Picker Dollies, moving output as well.")
  all_combinators[sc.unit_number].out.teleport(sc.position)
end

return this