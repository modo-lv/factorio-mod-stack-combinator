-- Libraries
local _event = require('__stdlib__/stdlib/event/event')

local ModEvents = {}

function ModEvents:register_all()
  _event
    .register(defines.events.on_tick, self.init)
    .on_configuration_changed(self.reload)
end

--- Unregister init handler after completion.
function ModEvents:unregister_init()
  _event.remove(defines.events.on_tick, self.init)
end

function ModEvents.init(ev)
  Mod:init()
end

function ModEvents.reload(ev)
  Mod.settings:load(true)
end

return ModEvents