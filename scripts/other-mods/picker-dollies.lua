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
  if (remote.interfaces["PickerDollies"]) then
    events.register(remote.call("PickerDollies", "dolly_moved_entity_id"), moved,
      function(ev)
        return ev.moved_entity and ev.moved_entity.name == This.StaCo.NAME
      end
    )

    events.register("dolly-rotate-rectangle", function(ev)
      -- Figuring out which entity was being rotated would require accessing PD's game data etc., so
      -- instead let's just ensure *all* StaCos are lined up with their outputs
      for _, sc in pairs(global.combinators) do
        moved({ moved_entity = sc.input })
      end
    end)

    -- Log that we've registered
    events.register(defines.events.on_player_joined_game, function()
      Mod.logger:debug("Picker Dollies detected, move & rotation handlers registered.")
    end)
  end
end

----------------------------------------------------------------------------------------------------

function PickerDollies.register_all()
  events.on_init(register)
  events.on_load(register)
end

----------------------------------------------------------------------------------------------------

return PickerDollies