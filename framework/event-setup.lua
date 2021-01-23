----------------------------------------------------------------------------------------------------
--- Register all framework events
----------------------------------------------------------------------------------------------------

local events = require('__stdlib__/stdlib/event/event')

----------------------------------------------------------------------------------------------------

local EventSetup = { }

function EventSetup:register_all()
  -- Runtime settings changed
  events.register(defines.events.on_runtime_mod_setting_changed, function()
    Mod.settings:load("runtime", true)
    Mod.settings:load("player", true)
  end)
end

----------------------------------------------------------------------------------------------------

return EventSetup