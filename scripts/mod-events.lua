--------------------------------------------------------------------------------
--- # Mod events
-- @type ModEvents
--------------------------------------------------------------------------------

local _event = require('__stdlib__/stdlib/event/event')

--------------------------------------------------------------------------------

local ModEvents = {}

--- Register mod-level runtime events
function ModEvents.register_all()
  _event.register(defines.events.on_runtime_mod_setting_changed, ModEvents.reload)
  -- Since our initialization needs the Game object, the only reliable way
  -- to do it on every load is to call in on the first tick 
  -- (and then immediately unregister)
  _event.register(defines.events.on_tick, ModEvents.init)    
  _event.on_configuration_changed(ModEvents.init)
end

--- Initialize the mod runtime
function ModEvents.init()
  Mod:init()
  _event.remove(defines.events.on_tick, ModEvents.init)
end

--- Reload mod settings
function ModEvents.reload()
  Mod.settings:load(true)
end

--------------------------------------------------------------------------------
return ModEvents